#! /bin/bash

#Prints welcome message
echo
echo "*****************************"
echo "Welcome to Password Manager!"
echo "*****************************"
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
	echo "------------------------------"
	case $choice in
        1) 
		# Choice 1. Enter a new password. Requests user input for service name and password. Generates a unique password id. Concatenates all three fields and appends to vault.txt as comma delimitted string
		choice_message="$choice_message 'Enter a new password'"
		echo $choice_message
		read -p "Enter the name of the service for which to store a password: " service
		read -p "Enter the password: " password
		previous_password_id=$(tail -n 1 vault.txt | awk -F ',' '{print $1}')
		new_password_id=$((previous_password_id + 1))
		echo "$new_password_id,$service,$password" >> vault.txt
		echo "Password saved succesfully"
		echo "------------------------------"
		echo
		;;

		2) 
		# Choice 2. Requests user input of a service name. Searches vault.txt column 2 for that service and then prints the associated password.
		choice_message="$choice_message 'View a saved password'"
		echo $choice_message
		read -p "Enter the name of the service to be viewed: " service
		requested_password=$(awk -F ',' -v serv="$service" '$2 == serv {print $3}' vault.txt)
		if [ -n "$requested_password" ]; then
			echo "The password for $service is: $requested_password"
		else
			echo "Service $service not found in the password vault."
		fi
		echo "------------------------------"
		echo
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
		# All invalid inputs will echo an error message and loop will reiterate
		echo "Invalid choice. Please try again"; echo ; echo "------------------------------"; echo
	esac
done

