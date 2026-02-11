#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ELEMENT=$1

MAIN_MENU()
{
  if [[ ! $ELEMENT ]]
  then
    echo "Please provide an element as an argument."
    return
  fi

  if [[ $ELEMENT =~ ^[A-Z]{1}$ ]]
  then
    ONE_LETTER $ELEMENT
  elif [[ $ELEMENT =~ ^[A-Z]{1}[a-z]{1}$ ]]
  then
    TWO_LETTERS $ELEMENT
  elif [[ $ELEMENT =~ ^[A-Z]{1}[a-z]+ ]]
  then
    WORD $ELEMENT
  elif [[ $ELEMENT =~ ^[0-9]+ ]]
  then
    NUMBER $ELEMENT
  else
    echo "I could not find that element in the database."
  fi
}

ONE_LETTER()
{
  ONE_LETTER_RESULT=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
  if [[ ! -z $ONE_LETTER_RESULT ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ONE_LETTER_RESULT'")
    TYPE=$($PSQL "SELECT type FROM types LEFT JOIN properties ON types.type_id=properties.type_id WHERE atomic_number=$ATOMIC_NUMBER")
    NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$ONE_LETTER_RESULT'")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($ONE_LETTER_RESULT). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  else
    echo "I could not find that element in the database."
  fi
}

TWO_LETTERS()
{
  TWO_LETTERS_RESULT=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
  if [[ ! -z $TWO_LETTERS_RESULT ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$TWO_LETTERS_RESULT'")
    TYPE=$($PSQL "SELECT type FROM types LEFT JOIN properties ON types.type_id=properties.type_id WHERE atomic_number=$ATOMIC_NUMBER")
    NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$TWO_LETTERS_RESULT'")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($TWO_LETTERS_RESULT). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  else
    echo "I could not find that element in the database."
  fi
}

WORD()
{
  WORD_RESULT=$($PSQL "SELECT name FROM elements WHERE name='$1'")
  if [[ ! -z $WORD_RESULT ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$WORD_RESULT'")
    TYPE=$($PSQL "SELECT type FROM types LEFT JOIN properties ON types.type_id=properties.type_id WHERE atomic_number=$ATOMIC_NUMBER")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$WORD_RESULT'")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    echo "The element with atomic number $ATOMIC_NUMBER is $WORD_RESULT ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $WORD_RESULT has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  else
    echo "I could not find that element in the database."
  fi
}

NUMBER()
{
  NUMBER_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number='$1'")
  if [[ ! -z $NUMBER_RESULT ]]
  then
    TYPE=$($PSQL "SELECT type FROM types LEFT JOIN properties ON types.type_id=properties.type_id WHERE atomic_number=$NUMBER_RESULT")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number='$NUMBER_RESULT'")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$NUMBER_RESULT'")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$NUMBER_RESULT")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$NUMBER_RESULT")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$NUMBER_RESULT")
    echo "The element with atomic number $NUMBER_RESULT is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  else
    echo "I could not find that element in the database."
  fi
}

MAIN_MENU
