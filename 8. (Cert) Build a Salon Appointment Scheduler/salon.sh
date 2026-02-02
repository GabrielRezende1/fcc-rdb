#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c";

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo -e "\n~~~~~ MY SALON ~~~~~\n"
  echo -e "Welcome to My Salon, how can I help you?\n"
  echo -e "1) Cut\n2) Color\n3) Permanent\n4) Style\n5) Trim\n6) Exit"

  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) SERVICE_MENU 1 ;;
    2) SERVICE_MENU 2 ;;
    3) SERVICE_MENU 3 ;;
    4) SERVICE_MENU 4 ;;
    5) SERVICE_MENU 5 ;;
    6) EXIT ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
}

SERVICE_MENU() {
  SERVICE_ID=$1
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$1" | xargs)

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'" | xargs)
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'" | xargs)
  echo -e "\nWhat time do you want your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id,customer_id,time) VALUES($SERVICE_ID,$CUSTOMER_ID,'$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

EXIT() {
  echo -e "\nThank you for stopping in.\n"
}

MAIN_MENU