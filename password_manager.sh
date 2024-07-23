#! /bin/bash

#Prints welcome message
echo
echo "------------------------------"
echo "Welcome to Password Manager!"
echo "------------------------------"
echo

#Options assigned to a variable for easier repeatability 
options="echo -e 'Please select from the following options:\n1. Enter a new password\n2. View a saved password\n3. Delete a password\n4. Exit Password Manager'"

# Create vault.txt if it doesn't exist
touch vault.txt

# While loop presents available options and evaluates user input
# User input 1, 2, or 3 will confirm the user's selection, carry out the appropriate action, then reset to option selection
# User input 4 will exit the program
while True; do
	eval $options #Present available options
	read -p "Enter your choice: " choice #Get input from user. 
	choice_message="You have selected" # Placeholder message stored in variable to be concatenated during case statement
	case $choice in
        1) 
		# Choice 1. Enter a new password. Requests user input for service and password. Generates a unique password id. Concatenates all three fields and appends to vault.txt as comma delimitted string
		choice_message="$choice_message 'Enter a new password'"
		echo $choice_message
		read -p "Enter the name of the service for which to store a password: " service
		read -p "Enter the password: " password
		previous_password_id=$(tail -n 1 vault.txt | awk -F ',' '{print $1}')
		new_password_id=$((previous_password_id + 1))
		echo "$new_password_id,$service,$password" >> vault.txt
		echo "Password saved succesfully"
		echo
		;;

		2) 
		choice_message="$choice_message 'View a saved password'"
		echo $choice_message
		break
		;;

		3) 
		choice_message="$choice_message 'Delete a password'"
		echo $choice_message
		break
		;;

		4) 
		choice_message="Goodbye!"
		echo $choice_message
		exit 1
		;;

		*) 
		echo "Invalid choice. Please try again"; echo ; echo "------------------------------"; echo
	esac
done

