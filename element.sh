#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ELEMENT_INFO=$1

# check element is number
if [[ -z $ELEMENT_INFO ]]
then
  echo Please provide an element as an argument.
elif [[ $ELEMENT_INFO =~ ^[0-9]+$ ]] 
then
  # if it does, search it with atomic_number
  CHECK=$($PSQL "SELECT atomic_number from elements WHERE atomic_number = $ELEMENT_INFO")
else
  # if it does not, serach it with symbol or name
  CHECK=$($PSQL "SELECT atomic_number from elements WHERE symbol = '$ELEMENT_INFO' OR name = '$ELEMENT_INFO'")
fi

if [[ -z $CHECK ]]
  then
    if [[ ! -z $ELEMENT_INFO ]]
    then
    echo "I could not find that element in the database."
    fi
  else
    ATOMIC_NUMBER=$CHECK
    ATOMIC_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    ATOMIC_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    ATOMIC_TYPE=$($PSQL "SELECT types.type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) where atomic_number = $ATOMIC_NUMBER")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM elements INNER JOIN properties USING(atomic_number) where atomic_number = $ATOMIC_NUMBER")
    ATOMIC_MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    ATOMIC_BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    echo "The element with atomic number $ATOMIC_NUMBER is $ATOMIC_NAME ($ATOMIC_SYMBOL). It's a $ATOMIC_TYPE, with a mass of $ATOMIC_MASS amu. $ATOMIC_NAME has a melting point of $ATOMIC_MELTING celsius and a boiling point of $ATOMIC_BOILING celsius."
fi
