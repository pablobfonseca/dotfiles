#!/usr/bin/env python3
import json
import os
import subprocess
import tempfile
import unittest

TOOL = os.path.join(os.path.dirname(os.path.abspath(__file__)), "queue-tool")

QUEUE = """# Tribemap Queue

## Next

> proposed: 2026-08-01
> 1. [[Tribemap Queue#^q3]] because reasons

- [ ] Committed item #feat ~S ^q1

## Ready

- [/] Fix crawl dedupe on empty sitemap #bug ~M (#901) →plan:[[Tribemap/plans/2026-07-20-crawl.md]] →pr:https://github.com/o/r/pull/12 ^q3
- [ ] Unstamped ready item ~XS

## Needs spec

- [ ] Vague thing → what does done mean ^q4

## Blocked

- [ ] Server stability → Performance Audit answers ^q5

## Someday

- [ ] Maybe later ^q6

## Shipped

- [x] Shipped with legacy plan [[PLAN TRIBEMAP-API-30]] (#877) ^q2
- [x] Ancient pre-id line
- [-] Dropped: superseded by q3 ^q5
"""

PLAN_WITH_BACKLINK = """---
queue: projects/Tribemap/Queue.md
queue_item: "Fix crawl dedupe on empty sitemap — absorbs ^q9's retry logic ^q3"
---

# Plan
"""

PLAN_ORPHAN = """---
tags: []
---

# Orphan plan
"""

PLAN_FOLDED = """---
queue: projects/Tribemap/Queue.md
queue_item: >-
  - [/] Vague thing → what does
  done mean ^q4
---

# Folded-scalar plan
"""


def run(*args, cwd=None):
    return subprocess.run(
        [TOOL, *args], capture_output=True, text=True, cwd=cwd
    )


class QueueToolTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.vault = self.tmp.name
        self.repo = tempfile.mkdtemp()
        os.makedirs(os.path.join(self.repo, "Tribemap"))
        with open(os.path.join(self.repo, "Tribemap", "Queue.md"), "w") as f:
            f.write(QUEUE)
        proj = os.path.join(self.vault, "projects", "Tribemap")
        os.makedirs(os.path.join(proj, "plans"))
        with open(os.path.join(proj, "Queue.md"), "w") as f:
            f.write(QUEUE)
        with open(os.path.join(proj, "plans", "2026-07-20-crawl.md"), "w") as f:
            f.write(PLAN_WITH_BACKLINK)
        with open(os.path.join(proj, "plans", "2026-07-21-orphan.md"), "w") as f:
            f.write(PLAN_ORPHAN)
        with open(os.path.join(proj, "plans", "2026-07-22-folded.md"), "w") as f:
            f.write(PLAN_FOLDED)

    def tearDown(self):
        self.tmp.cleanup()

    def dump(self):
        r = run_tool(self.repo, "dump", "Tribemap")
        self.assertEqual(r.returncode, 0, r.stderr)
        return json.loads(r.stdout)

    def item(self, d, qid):
        return next(i for i in d["items"] if i["id"] == qid)

    def test_dump_parses_lanes_and_states(self):
        d = self.dump()
        q3 = self.item(d, "q3")
        self.assertEqual(q3["lane"], "Ready")
        self.assertEqual(q3["state"], "in_progress")
        q2 = self.item(d, "q2")
        self.assertEqual(q2["lane"], "Shipped")
        self.assertEqual(q2["state"], "done")

    def test_dump_parses_markers(self):
        q3 = self.item(self.dump(), "q3")
        self.assertEqual(q3["tags"], ["bug"])
        self.assertEqual(q3["size"], "M")
        self.assertEqual(q3["issue"], 901)
        self.assertEqual(q3["plan"], "[[Tribemap/plans/2026-07-20-crawl.md]]")
        self.assertEqual(q3["pr"], "https://github.com/o/r/pull/12")
        self.assertEqual(q3["text"], "Fix crawl dedupe on empty sitemap")

    def test_dump_ignores_proposed_blockquote(self):
        d = self.dump()
        self.assertFalse(any("because reasons" in i["raw"] for i in d["items"]))

    def test_dump_reports_duplicate_ids(self):
        self.assertEqual(self.dump()["duplicates"], ["q5"])

    def test_dump_reports_unstamped_outside_shipped(self):
        d = self.dump()
        self.assertEqual(len(d["unstamped"]), 1)
        self.assertIn("Unstamped ready item", d["unstamped"][0]["raw"])

    def test_dump_next_id_is_max_plus_one(self):
        self.assertEqual(self.dump()["next_id"], "q7")

    def test_find_by_id_variants(self):
        for arg in ("q3", "3", "^q3"):
            r = run_tool(self.repo, "find", "Tribemap", arg)
            self.assertEqual(r.returncode, 0, r.stderr)
            m = json.loads(r.stdout)
            self.assertEqual(m["id"], "q3")
            self.assertEqual(m["lane"], "Ready")

    def test_find_by_issue_ref(self):
        r = run_tool(self.repo, "find", "Tribemap", "#901")
        self.assertEqual(r.returncode, 0, r.stderr)
        m = json.loads(r.stdout)
        self.assertEqual(m["id"], "q3")
        self.assertEqual(m["issue"], 901)

    def test_find_by_text_fragment(self):
        r = run_tool(self.repo, "find", "Tribemap", "server stability")
        m = json.loads(r.stdout)
        self.assertEqual(m["id"], "q5")
        self.assertEqual(m["lane"], "Blocked")

    def test_find_missing_fails(self):
        r = run_tool(self.repo, "find", "Tribemap", "q999")
        self.assertNotEqual(r.returncode, 0)

    def test_plans_extracts_backlinks_and_orphans(self):
        r = run("plans", "Tribemap", "--vault", self.vault)
        self.assertEqual(r.returncode, 0, r.stderr)
        plans = json.loads(r.stdout)
        by_file = {p["file"]: p for p in plans}
        linked = by_file["2026-07-20-crawl.md"]
        self.assertEqual(linked["queue"], "projects/Tribemap/Queue.md")
        self.assertEqual(linked["queue_item_id"], "q3")
        orphan = by_file["2026-07-21-orphan.md"]
        self.assertIsNone(orphan["queue_item"])
        folded = by_file["2026-07-22-folded.md"]
        self.assertEqual(folded["queue_item_id"], "q4")

    def test_missing_queue_fails_loudly(self):
        r = run_tool(self.repo, "dump", "NoSuch")
        self.assertNotEqual(r.returncode, 0)
        self.assertIn("Queue.md", r.stderr)


def sh(cwd, *args):
    return subprocess.run(args, cwd=cwd, capture_output=True, text=True)


CLEAN_QUEUE = QUEUE.replace("- [-] Dropped: superseded by q3 ^q5",
                            "- [-] Dropped: superseded by q3")


def make_repo_pair():
    base = tempfile.mkdtemp()
    bare = os.path.join(base, "remote.git")
    sh(base, "git", "init", "--bare", "-q", bare)
    a = os.path.join(base, "a")
    b = os.path.join(base, "b")
    for clone in (a, b):
        sh(base, "git", "clone", "-q", bare, clone)
        sh(clone, "git", "config", "user.email", "t@t")
        sh(clone, "git", "config", "user.name", "t")
    os.makedirs(os.path.join(a, "Tribemap"))
    with open(os.path.join(a, "Tribemap", "Queue.md"), "w") as f:
        f.write(CLEAN_QUEUE)
    sh(a, "git", "add", "-A")
    sh(a, "git", "commit", "-q", "-m", "seed")
    sh(a, "git", "push", "-q", "-u", "origin", "HEAD")
    sh(b, "git", "pull", "-q")
    return base, bare, a, b


def run_tool(env_repo, *args):
    env = dict(os.environ, VAULT_QUEUES=env_repo)
    return subprocess.run([TOOL, *args], capture_output=True, text=True, env=env)


class GitPlumbingTest(unittest.TestCase):
    def test_dump_reads_from_queues_repo(self):
        base, bare, a, b = make_repo_pair()
        r = run_tool(a, "dump", "Tribemap")
        self.assertEqual(r.returncode, 0, r.stderr)
        data = json.loads(r.stdout)
        self.assertEqual(data["next_id"], "q7")
        self.assertEqual(data["duplicates"], [])

    def test_dump_pulls_fresh_remote_state(self):
        base, bare, a, b = make_repo_pair()
        qb = os.path.join(b, "Tribemap", "Queue.md")
        with open(qb, "a") as f:
            f.write("\n- [ ] Fresh from machine B ^q10\n")
        sh(b, "git", "commit", "-aqm", "b edit")
        sh(b, "git", "push", "-q")
        r = run_tool(a, "dump", "Tribemap")
        self.assertIn("Fresh from machine B", r.stdout)

    def test_dump_offline_warns_and_uses_local(self):
        base, bare, a, b = make_repo_pair()
        sh(a, "git", "remote", "set-url", "origin", "/nonexistent")
        r = run_tool(a, "dump", "Tribemap")
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertIn("warning", r.stderr.lower())

    def test_dump_plain_dir_still_works(self):
        d = tempfile.mkdtemp()
        os.makedirs(os.path.join(d, "Tribemap"))
        with open(os.path.join(d, "Tribemap", "Queue.md"), "w") as f:
            f.write(QUEUE)
        r = run_tool(d, "dump", "Tribemap")
        self.assertEqual(r.returncode, 0, r.stderr)


class MutationTest(unittest.TestCase):
    def tool(self):
        import importlib.util
        from importlib.machinery import SourceFileLoader
        loader = SourceFileLoader("qt", TOOL)
        spec = importlib.util.spec_from_loader("qt", loader)
        mod = importlib.util.module_from_spec(spec)
        loader.exec_module(mod)
        return mod

    def test_state_wip(self):
        qt = self.tool()
        out = qt.mutate_state(QUEUE, "q1", "wip")
        self.assertIn("- [/] Committed item #feat ~S ^q1", out)

    def test_state_dropped_requires_reason(self):
        qt = self.tool()
        with self.assertRaises(SystemExit):
            qt.mutate_state(QUEUE, "q1", "dropped")
        out = qt.mutate_state(QUEUE, "q1", "dropped", "superseded")
        self.assertIn("- [-] Committed item #feat ~S (dropped: superseded) ^q1", out)

    def test_state_unknown_id_dies(self):
        qt = self.tool()
        with self.assertRaises(SystemExit):
            qt.mutate_state(QUEUE, "q999", "wip")

    def test_lane_move_appends_to_target(self):
        qt = self.tool()
        out = qt.mutate_lane(QUEUE, "q4", "Ready")
        ready = out.split("## Ready")[1].split("## Needs spec")[0]
        self.assertIn("Vague thing", ready)
        needs = out.split("## Needs spec")[1].split("## Blocked")[0]
        self.assertNotIn("Vague thing", needs)

    def test_mark_plan_inserts_before_id(self):
        qt = self.tool()
        out = qt.mutate_mark(QUEUE, "q1", plan="[[Tribemap/plans/x]]")
        self.assertIn("- [ ] Committed item #feat ~S →plan:[[Tribemap/plans/x]] ^q1", out)

    def test_mark_replaces_existing_pr(self):
        qt = self.tool()
        out = qt.mutate_mark(QUEUE, "q3", pr="https://x/2")
        self.assertIn("→pr:https://x/2", out)
        self.assertNotIn("→pr:https://github.com/o/r/pull/12", out)

    def test_add_stamps_next_id(self):
        qt = self.tool()
        out, qid = qt.mutate_add(QUEUE, "Ready", "New thing #feat ~S")
        self.assertEqual(qid, "q7")
        self.assertIn("- [ ] New thing #feat ~S ^q7", out)

    def test_stamp_all_skips_shipped(self):
        qt = self.tool()
        out, ids = qt.mutate_stamp(QUEUE)
        self.assertEqual(ids, ["q7"])
        self.assertIn("- [ ] Unstamped ready item ~XS ^q7", out)
        self.assertIn("- [x] Ancient pre-id line\n", out)


class TransactTest(unittest.TestCase):
    def test_state_commits_and_pushes(self):
        base, bare, a, b = make_repo_pair()
        vault = tempfile.mkdtemp()
        os.makedirs(os.path.join(vault, "projects", "Tribemap"))
        r = run_tool(a, "state", "Tribemap", "q1", "wip", "--vault", vault)
        self.assertEqual(r.returncode, 0, r.stderr)
        sh(b, "git", "pull", "-q")
        with open(os.path.join(b, "Tribemap", "Queue.md")) as f:
            self.assertIn("- [/] Committed item", f.read())
        with open(os.path.join(vault, "projects", "Tribemap", "Queue.md")) as f:
            view = f.read()
        self.assertIn("Generated view", view)
        self.assertIn("- [/] Committed item", view)

    def test_state_merges_concurrent_remote_edit(self):
        base, bare, a, b = make_repo_pair()
        vault = tempfile.mkdtemp()
        os.makedirs(os.path.join(vault, "projects", "Tribemap"))
        qb = os.path.join(b, "Tribemap", "Queue.md")
        with open(qb) as f:
            content = f.read()
        with open(qb, "w") as f:
            f.write(content.replace("Maybe later ^q6", "Maybe later soon ^q6"))
        sh(b, "git", "commit", "-aqm", "b edit")
        sh(b, "git", "push", "-q")
        r = run_tool(a, "state", "Tribemap", "q1", "wip", "--vault", vault)
        self.assertEqual(r.returncode, 0, r.stderr)
        sh(b, "git", "pull", "-q")
        with open(qb) as f:
            final = f.read()
        self.assertIn("Maybe later soon ^q6", final)
        self.assertIn("- [/] Committed item", final)

    def test_state_offline_commits_locally(self):
        base, bare, a, b = make_repo_pair()
        vault = tempfile.mkdtemp()
        os.makedirs(os.path.join(vault, "projects", "Tribemap"))
        sh(a, "git", "remote", "set-url", "origin", "/nonexistent")
        r = run_tool(a, "state", "Tribemap", "q1", "wip", "--vault", vault)
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertIn("unpushed", r.stderr)
        log = sh(a, "git", "log", "--oneline", "-1").stdout
        self.assertIn("q: state Tribemap q1 wip", log)

    def test_duplicate_ids_refuse_mutation(self):
        base, bare, a, b = make_repo_pair()
        vault = tempfile.mkdtemp()
        qa = os.path.join(a, "Tribemap", "Queue.md")
        with open(qa, "a") as f:
            f.write("\n- [ ] Dup line ^q1\n")
        sh(a, "git", "commit", "-aqm", "corrupt")
        sh(a, "git", "push", "-q")
        r = run_tool(a, "state", "Tribemap", "q6", "wip", "--vault", vault)
        self.assertNotEqual(r.returncode, 0)
        self.assertIn("duplicate", r.stderr.lower())


class SubcommandTest(unittest.TestCase):
    def setup_pair(self):
        base, bare, a, b = make_repo_pair()
        vault = tempfile.mkdtemp()
        os.makedirs(os.path.join(vault, "projects", "Tribemap"))
        return a, b, vault

    def read(self, clone):
        sh(clone, "git", "pull", "-q")
        with open(os.path.join(clone, "Tribemap", "Queue.md")) as f:
            return f.read()

    def test_lane(self):
        a, b, vault = self.setup_pair()
        r = run_tool(a, "lane", "Tribemap", "q4", "Ready", "--vault", vault)
        self.assertEqual(r.returncode, 0, r.stderr)
        ready = self.read(b).split("## Ready")[1].split("## Needs spec")[0]
        self.assertIn("Vague thing", ready)

    def test_mark_pr(self):
        a, b, vault = self.setup_pair()
        r = run_tool(a, "mark", "Tribemap", "q1", "--pr", "https://x/9", "--vault", vault)
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertIn("→pr:https://x/9 ^q1", self.read(b))

    def test_add_mints_and_reports_id(self):
        a, b, vault = self.setup_pair()
        r = run_tool(a, "add", "Tribemap", "Brand new item ~S", "--lane", "Ready", "--vault", vault)
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertEqual(json.loads(r.stdout)["id"], "q7")
        self.assertIn("- [ ] Brand new item ~S ^q7", self.read(b))

    def test_add_refuses_offline(self):
        a, b, vault = self.setup_pair()
        sh(a, "git", "remote", "set-url", "origin", "/nonexistent")
        r = run_tool(a, "add", "Tribemap", "X", "--lane", "Ready", "--vault", vault)
        self.assertNotEqual(r.returncode, 0)
        self.assertIn("offline", r.stderr)

    def test_stamp(self):
        a, b, vault = self.setup_pair()
        r = run_tool(a, "stamp", "Tribemap", "--vault", vault)
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertEqual(json.loads(r.stdout)["ids"], ["q7"])
        self.assertIn("Unstamped ready item ~XS ^q7", self.read(b))

    def test_push_flushes_offline_commits(self):
        a, b, vault = self.setup_pair()
        url = sh(a, "git", "remote", "get-url", "origin").stdout.strip()
        sh(a, "git", "remote", "set-url", "origin", "/nonexistent")
        run_tool(a, "state", "Tribemap", "q1", "wip", "--vault", vault)
        sh(a, "git", "remote", "set-url", "origin", url)
        r = run_tool(a, "push", "--vault", vault)
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertIn("- [/] Committed item", self.read(b))

    def test_view_all(self):
        a, b, vault = self.setup_pair()
        r = run_tool(a, "view", "--all", "--vault", vault)
        self.assertEqual(r.returncode, 0, r.stderr)
        with open(os.path.join(vault, "projects", "Tribemap", "Queue.md")) as f:
            self.assertIn("Generated view", f.read())


if __name__ == "__main__":
    unittest.main(verbosity=2)
