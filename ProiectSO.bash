#!/bin/bash

if [ $# -gt 0 ]; then
  echo -e "cars: argument error" >&2
  echo "usage: cars" >&2
  exit 1
fi

BASE="$HOME/AlexPopa/cars.list"


if [ ! -f "$BASE" ]; then
  echo "Creating cars.list file..."
  touch "$BASE"
fi

while :
do
  echo -e "
carbase=$BASE
MENU
------------------------------
add car to database (a)
delete car from database (d)
edit database (e)
search for car in database (s)
view complete database (v)
sort by car make (m)
sort by car year (y)
<ENTER> exit program
Press a/d/e/s/v/m/y or <ENTER>:\c
------------------------------
"
  read answ
  case $answ in
    "")
      exit 0
      ;;
    a|A)
      echo -e "Enter car ID:\c"
      read id

      
      if ! [[ $id =~ ^[0-9]+$ ]]; then
        echo "ID must be a number!"
        continue
      fi

      
      if grep -q "^$id[[:space:]]" "$BASE"; then
        echo "ID $id already exists in the car database!"
        continue
      fi

      echo -e "Enter car make:\c"
      read make
      if [ -z "$make" ]; then
        continue
      fi
      echo -e "Enter car model:\c"
      read model
      echo -e "Enter car year:\c"
      read year

      
      if ! [[ $year =~ ^[0-9]+$ ]]; then
        echo "Year must be a number!"
        continue
      fi

      echo -e "Enter car color:\c"
      read color

      echo -e "$id\t$make\t$model\t$year\t$color" >> "$BASE"
      echo -e "Car was added!"
      ;;
    d|D)
      echo -e "Enter car ID to delete (<ENTER> to exit):\c"
      read id
      if [ -z "$id" ]; then
        continue
      fi
      grep -v -i "^$id[[:space:]]" "$BASE" > "$BASE.new"
      mv "$BASE.new" "$BASE"
      echo -e "Car with ID $id was deleted!"
      ;;
    e|E)
      pico "$BASE"
      ;;
    s|S)
      echo -e "\nEnter car make to search:\c"
      read -r make
      grep -i "$make" "$BASE" > /dev/null
      if [ "$?" -eq 0 ]; then
        echo -e "\n--------------------"
        grep -i "$make" "$BASE"
        echo -e "--------------------\n"
      else
        echo "$make not found in the car database!"
      fi
      ;;

    v|V)
      echo -e "\n\t Car Database\n\t---------------"
      more "$BASE"
      echo -e "\nPress <ENTER> to continue"
      read answ
      ;;
    m|M)
      sort -t $'\t' -k2 -o "$BASE" "$BASE"
      echo -e "Car database sorted by car make!"
      ;;
    y|Y)
      sort -t $'\t' -k4rn -o "$BASE" "$BASE"
      echo -e "Car database sorted by car year (descending)!"
      ;;
    *)
      echo -e "Not a valid command!"
      ;;
  esac
done
