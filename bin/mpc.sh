csong=$(mpc current)
playing=$(mpc status | grep -o 'playing' )
p=" "

if [ "$playing" == "playing" ]; then
  echo "$af0$txt $csong$p"
else [ "$playing" == "" ];
  echo ""
fi
