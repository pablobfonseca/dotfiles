function prompt_rvm {
  rbv=`rvm-prompt`
  rbv=${rbv#ruby-}
  [[ $rbv == *"@"* ]] || rbv="${rbv}@default"
  echo $rbv
}
