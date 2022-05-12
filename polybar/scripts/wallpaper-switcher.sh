#!/bin/bash

IS_LOCKED=false
MAX_SPEED=3
SPEED=1
speed=.config/polybar/scripts/wallpaper-dot-files/wallpaper-switcher.speed
process=.config/polybar/scripts/wallpaper-dot-files/wallpaper-switcher.pid
lock=.config/polybar/scripts/wallpaper-dot-files/wallpaper-switcher.lock
folder=~/Images/random/*

############################## speed ########################
# to read value from the config file or default one
get_values() {
  [ ! -f "$speed" ] && write_speed 1
  source $speed
  [ -f "$process" ] && source $process
}

# to save value in the speed file
write_speed() {
    echo "SPEED=$1" > $speed
}

# to increase the speed value until MAX_SPEED
cycle_speed_value(){
  if [ -f "$lock" ]
  then
    randomize
  else
    stop_process
    if [ "$SPEED" -ge "$MAX_SPEED" ]
    then
      SPEED=1
    else
      SPEED=$(($SPEED+1))
    fi
    write_speed $SPEED
    get_values
    start_process
  fi
}

######################## randomize wallpaper ###################
# select a random wallpaper in the folder
randomize(){
  feh --randomize --bg-scale $folder
}

# convert speed value into steps
convert_speed(){
  case "$SPEED" in
     1)
       true_speed=1200
       ;;
     2)
       true_speed=60
       ;;
     3)
       true_speed=10
       ;;
     *)
       true_speed=1200
 esac
 echo $true_speed
}

# launch the randomize instruction based on the speed value
wait_and_feh(){
  local true_speed=$(convert_speed)
  while true
  do
      randomize
      sleep $true_speed
  done
}

# start the process and keep the pid value
start_process(){
  wait_and_feh &
  echo "PROCESS_PID=$!" > $process
}

# kill the process
stop_process(){
  get_values
  if ps -p $PROCESS_PID > /dev/null
  then
    kill $PROCESS_PID
  fi
}

####################### lock wallpaper #####################

# to switch between lock and unlock
lock_switcher(){
    if [ -f "$lock" ]
    then
      unlock_wallpaper
    else
      lock_wallpaper
    fi
}

# stop process and create a lock file
lock_wallpaper() {
    touch $lock
    get_values
    stop_process
#    [ -f "$process" ] && rm $process
}

# restart the process and remove the lock file
unlock_wallpaper(){
    [ -f "$lock" ] && rm $lock
    start_process
}

get_speed(){
  get_values
  if [ -f "$lock" ]
  then
    echo  %{T3}%{F#a2afc5}  %{F-}%{T-}
  else
      case "$SPEED" in
         1)
            echo  %{T3}%{F#a2afc5}    %{F-}%{T-} :  %{T3}%{F#a2afc5} %{F-}%{T-}
           ;;
         2)
            echo  %{T3}%{F#a2afc5}    %{F-}%{T-}:  %{T3}%{F#a2afc5} %{F-}%{T-}
           ;;
         3)
            echo  %{T3}%{F#a2afc5}    %{F-}%{T-}:  %{T3}%{F#a2afc5}  %{F-}%{T-}
           ;;
         *)
            echo  %{T3}%{F#a2afc5}    %{F-}%{T-}:  %{T3}%{F#a2afc5}   %{F-}%{T-}
    esac
  fi
}


# cases for polybar user_module.ini
case "$1" in
	--lock) lock_wallpaper ;;
	--unlock) unlock_wallpaper ;;
  --read) get_values;;
  --increase) cycle_speed_value;;
  --get_speed) get_speed;;
  --switch)lock_switcher;;
  --randomize)randomize;;
	*)
	  stop_process
	  write_speed 1  ;;
esac
