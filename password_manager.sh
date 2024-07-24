#! /bin/bash

#Prints welcome message
echo
echo "*****************************"
echo "Welcome to Password Manager!"
echo "*****************************"
echo

#Options assigned to a variable for easier repeatability 
options="echo -e 'Please select from the following options:\n1. Create or update an entry\n2. View entries\n3. Delete entry\n4. Exit Password Manager'"

# Create vault.txt if it doesn't exist
touch vault.txt
chmod 600 vault.txt

# 'While' loop presents available options and evaluates user input
# User input 1, 2, or 3 will confirm the user's selection, carry out the appropriate action, then reset to option selection
# User input 4 will exit the program
while True; do
	eval $options #Present available options
	read -p "Enter your choice: " choice #Get input from user. 
	choice_message="You have selected:" # Placeholder message stored in variable to be concatenated during case statement
	echo "------------------------------"
	echo
	case $choice in
        1) 
		# Choice 1. Enter a new password. Requests user input for service name and password. Generates a unique password id. Concatenates all three fields and appends to vault.txt as comma delimitted string
		choice_message="$choice_message 'Create or update an entry'"
		echo $choice_message
		read -p "Enter the name of the service for which to store/update a password: " service
		echo
		existing_entry=$(awk -v serv="$service" '$2 == serv {print  $0}' vault.txt)
		if [ -n "$existing_entry" ]; then
			while True; do
				read -p "Password entry already exists for $service. Would you like to update this entry? [y/n]: " choice
				echo
				if [ "$choice" = "y" ]; then
					read -p "Enter the new username: " new_user
					read -p "Enter the new password: " new_pass
					awk -v serv="$service" -v user="$new_user" -v pass="$new_pass" '$2 == serv {$3=user; $4=pass} {print}' vault.txt > tmpfile && mv tmpfile vault.txt
					echo "Password updated successfully"
					echo "------------------------------"
					echo
					break
				elif [ "$choice" = 'n' ]; then
					break
				else
					echo "Invalid selection"
					echo "------------------------------"
					echo
				fi
			done
		else
			read -p "Enter the username: " username
			read -p "Enter the password: " password
			last_entry_id=$(tail -n 1 vault.txt | awk '{print $1}')
			new_password_id=$((last_entry_id + 1))
			echo "$new_password_id $service $username $password" >> vault.txt
			echo "Password saved succesfully"
			echo "------------------------------"
			echo
		fi
		;;

		2) 
		# Choice 2. Requests user input of a service name. Searches vault.txt column 2 for that service and then prints the associated password.
		choice_message="$choice_message 'View entries'"
		echo "$choice_message"
		echo -e "Please select from the following options:\n1. View all entries\n2. View a single entry"
		read -p "Option: " choice
		echo
		while True; do
			if [ "$choice" = "1" ]; then
				echo -e "ID\tService\tUsername\tPassword\n$(cat vault.txt)" | column -t
				echo "------------------------------"
				echo
				break
			elif [ "$choice" = "2" ]; then
				read -p "Enter the name of the service to be viewed: " service
				echo
				# Retrieve both username and password in a single awk command
				requested_credentials=$(awk -v serv="$service" '$2 == serv {print $0}' vault.txt)
				requested_username=$(echo "$requested_credentials" | awk '{print $3}')
				requested_password=$(echo "$requested_credentials" | awk '{print $4}')
				# 'if' statement displays error if service is not recorded in vault.txt
				if [ -n "$requested_username" ] && [ -n "$requested_password" ]; then
					echo "The username for $service is: $requested_username"
					echo "The password for $service is: $requested_password"
					echo "------------------------------"
					echo
					break
				else
					echo "Service $service not found in the password vault."
					echo "------------------------------"
					echo
					break
				fi
			else
				echo "Invalid selection"
				echo "------------------------------"
				echo
			fi
		done
		;;

		3) 
		# Choice 3. Requests user input of service to be deleted. Searches vault.txt for service and removes line if there is a match. 
		choice_message="$choice_message 'Delete entry'"
		echo $choice_message
		echo -e "Please select from the following options:\n1. Delete a single entry\n2. Delete all entries"
		read -p "Option: " choice
		echo
		while True; do
			if [ "$choice" = "1" ]; then
				read -p "Enter the name of the service to be deleted: " service
				echo
				requested_deletion_line=$(awk -v serv="$service" '$2 == serv {print NR}' vault.txt)
				# 'if' statement displays error if service is not recorded in vault.txt
				if [ -n "$requested_deletion_line" ]; then
					read -p "The entry for $service will be permanently deleted. Are you sure? [y/n]: " confirm
					if [ "$confirm" = "y" ]; then
						# sed creates a copy of vault.txt called vault.txt.temp then replaces the original with the designated line removed. rm command deletes temp file after it is no longer needed
						sed -i .temp "${requested_deletion_line}d" vault.txt ; rm vault.txt.temp 
						echo "The password for $service has been deleted."
						echo "------------------------------"
						echo
						break
					else
						echo "Delete action cancelled"
						echo "------------------------------"
						echo
						break
					fi
				else
					echo "Service $service not found in the password vault."
					echo "------------------------------"
					echo
					break
				fi
			elif [ "$choice" = "2" ]; then
				read -p "All entries will be permanently deleted. Are you sure? [y/n]: " confirm
				echo
				if [ "$confirm" = "y" ]; then
					$(> vault.txt)
					echo "All entries deleted succesfully"
					break
				else
					echo "Delete action cancelled"
					echo "------------------------------"
					echo
					break
				fi
			else
				echo "Invalid selection"
				echo "------------------------------"
				echo
			fi
		done
		;;

		4) 
		# Displays exit message and exits program
		choice_message="Goodbye!"
		echo $choice_message
		exit 0
		;;

		*) 
		# All invalid inputs will display an error message and loop will reiterate, reprompting the user and displaying options
		echo "Invalid choice. Please try again"; echo ; echo "------------------------------"; echo
	esac
done

