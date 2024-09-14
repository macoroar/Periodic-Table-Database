#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

SYMBOL=$1

if [[ -z $1  ]]
then
echo "Please provide an element as an argument."
else
# Check if argument is provided
if [[ -z $SYMBOL ]]; then
  echo "Please provide an element as an argument."
fi

# if input is not a number
if [[ ! $SYMBOL =~ ^[0-9]+$ ]]; then

  # if input is greater than two letters
  LENGTH=$(echo -n "$SYMBOL" | wc -m)
  if [[ $LENGTH -gt 2 ]]; then

    # get data by full name
    DATA=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE name='$SYMBOL'")
    
    if [[ -z $DATA ]]; then
      echo "I could not find that element in the database."
    else
      # Set Internal Field Separator (IFS) to pipe (|) to parse the output correctly
      echo "$DATA" | while IFS="|" read NUMBER SYMBOL NAME WEIGHT MELTING BOILING TYPE; do
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    fi

  else

    # get data by atomic symbol
    DATA=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE symbol='$SYMBOL'")
    
    if [[ -z $DATA ]]; then
      echo "I could not find that element in the database."
    else
      echo "$DATA" | while IFS="|" read NUMBER SYMBOL NAME WEIGHT MELTING BOILING TYPE; do
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    fi

  fi

else

  # get data by atomic number
  DATA=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number='$SYMBOL'")
  
  if [[ -z $DATA ]]; then
    echo "I could not find that element in the database."
  else
    echo "$DATA" | while IFS="|" read NUMBER SYMBOL NAME WEIGHT MELTING BOILING TYPE; do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi

fi

fi

