#!/bin/bash

# Function to display services
display_services() {
  echo -e "\nHere are the services we offer:"
  echo "1) Connection"
  echo "2) Repairs"
  echo "3) Legal"
}

# Main program
while true; do
  # Display the list of services before prompting
  display_services

  # Prompt user for service ID
  echo -n "Enter the service ID you want: "
  read SERVICE_ID_SELECTED

  # Validate service ID
  case $SERVICE_ID_SELECTED in
    1) SERVICE_NAME="Connection" ;;
    2) SERVICE_NAME="Repairs" ;;
    3) SERVICE_NAME="Legal" ;;
    *)
      echo -e "\nInvalid service ID. Please choose from the list again."
      continue
      ;;
  esac

  # Prompt for phone number
  echo -n "Enter your phone number: "
  read CUSTOMER_PHONE

  # Check if customer exists
  CUSTOMER_NAME=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';" | xargs)
  if [[ -z "$CUSTOMER_NAME" ]]; then
    echo "New customer detected! Please enter your name: "
    read CUSTOMER_NAME
    # Insert new customer
    psql --username=freecodecamp --dbname=salon -c "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME');"
  fi

  # Prompt for appointment time
  echo -n "Enter your preferred appointment time: "
  read SERVICE_TIME

  # Get customer ID
  CUSTOMER_ID=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';" | xargs)

  # Insert appointment
  psql --username=freecodecamp --dbname=salon -c "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');"

  # Confirm appointment
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

  # Exit after successful input
  break
done
