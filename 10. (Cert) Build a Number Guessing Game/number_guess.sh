#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=guess_game -t --no-align -c"

GUESS_NUMBER()
{
  TRIES=1
  NUMBER=$((RANDOM % 1000 + 1))
  echo "Guess the secret number between 1 and 1000:"
  read GUESS
  while [[ $GUESS != $NUMBER ]]
  do
    if [[ $GUESS =~ [a-zA-Z]+ ]]
    then
      echo "That is not an integer, guess again:"
      read GUESS
    elif [[ $GUESS > $NUMBER ]]
    then
      TRIES=$(($TRIES + 1))
      echo "It's lower than that, guess again:"
      read GUESS
    else
      TRIES=$(($TRIES + 1))
      echo "It's higher than that, guess again:"
      read GUESS
    fi
  done
  echo "You guessed it in $TRIES tries. The secret number was $NUMBER. Nice job!"
}

echo "Enter your username:"
read USERNAME
USERNAME_RESULT=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
# Check username existence
if [[ -z $USERNAME_RESULT ]]
then
  # Insert new user
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  GUESS_NUMBER
  NEW_USER=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USERNAME', 1, $TRIES)")
else
  # Update user
  GAMES_PLAYED_RESULT=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME_RESULT'")
  BEST_GAME_RESULT=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME_RESULT'")
  echo "Welcome back, $USERNAME_RESULT! You have played $GAMES_PLAYED_RESULT games, and your best game took $BEST_GAME_RESULT guesses."
  GUESS_NUMBER
  UPDATE_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played=games_played+1 WHERE username='$USERNAME_RESULT'")
  if [[ $TRIES < $BEST_GAME_RESULT ]]
  then
    UPDATE_BEST_GAME=$($PSQL "UPDATE users SET best_game=$TRIES WHERE username='$USERNAME_RESULT'")
  fi
fi
