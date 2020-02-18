function scp
  rsync --archive --progress --checksum --compress --human-readable --itemize-changes --rsh=ssh --stats --verbose
end
