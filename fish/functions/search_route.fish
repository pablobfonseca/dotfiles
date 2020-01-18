function search_route
  bin/rake routes | rg $argv
end

