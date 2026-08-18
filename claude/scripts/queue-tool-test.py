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
queue_item: "Fix crawl dedupe on empty sitemap ^q3"
---

# Plan
"""

PLAN_ORPHAN = """---
tags: []
---

# Orphan plan
"""


def run(*args, cwd=None):
    return subprocess.run(
        [TOOL, *args], capture_output=True, text=True, cwd=cwd
    )


class QueueToolTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.vault = self.tmp.name
        proj = os.path.join(self.vault, "projects", "Tribemap")
        os.makedirs(os.path.join(proj, "plans"))
        with open(os.path.join(proj, "Queue.md"), "w") as f:
            f.write(QUEUE)
        with open(os.path.join(proj, "plans", "2026-07-20-crawl.md"), "w") as f:
            f.write(PLAN_WITH_BACKLINK)
        with open(os.path.join(proj, "plans", "2026-07-21-orphan.md"), "w") as f:
            f.write(PLAN_ORPHAN)

    def tearDown(self):
        self.tmp.cleanup()

    def dump(self):
        r = run("dump", "Tribemap", "--vault", self.vault)
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
            r = run("find", "Tribemap", arg, "--vault", self.vault)
            self.assertEqual(r.returncode, 0, r.stderr)
            m = json.loads(r.stdout)
            self.assertEqual(m["id"], "q3")
            self.assertEqual(m["lane"], "Ready")

    def test_find_by_issue_ref(self):
        r = run("find", "Tribemap", "#901", "--vault", self.vault)
        self.assertEqual(r.returncode, 0, r.stderr)
        m = json.loads(r.stdout)
        self.assertEqual(m["id"], "q3")
        self.assertEqual(m["issue"], 901)

    def test_find_by_text_fragment(self):
        r = run("find", "Tribemap", "server stability", "--vault", self.vault)
        m = json.loads(r.stdout)
        self.assertEqual(m["id"], "q5")
        self.assertEqual(m["lane"], "Blocked")

    def test_find_missing_fails(self):
        r = run("find", "Tribemap", "q999", "--vault", self.vault)
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

    def test_missing_queue_fails_loudly(self):
        r = run("dump", "NoSuch", "--vault", self.vault)
        self.assertNotEqual(r.returncode, 0)
        self.assertIn("Queue.md", r.stderr)


if __name__ == "__main__":
    unittest.main(verbosity=2)
