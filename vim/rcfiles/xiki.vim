function! XikiLaunch()
  ruby << EOF
    xiki_dir = ENV['XIKI_DIR']
    ['ol', 'vim/line', 'vim/tree'].each {|o| require "#{xiki_dir}/lib/xiki/#{o}"}
    line = Line.value
    indent = line[/^ +/]
    command = "xsh #{line}"
    result = `#{command}`
    Tree << result
EOF
endfunction

nmap <2-LeftMouse> :call XikiLaunch()<cr>
imap <2-LeftMouse> <C-c> :call XikiLaunch()<cr>i
imap <c-cr> <C-c> :call XikiLaunch()<cr>i
nmap <c-cr> :call XikiLaunch()<cr>
