#! /bin/bash

#Prints welcome message
echo
echo "*****************************"
echo "Welcome to Password Manager!"
echo "*****************************"
echo

#main_menu assigned to a variable for easier repeatability 
main_menu="echo -e 'MAIN MENU:\n1. Create or update an entry\n2. View entries\n3. Delete entry\n4. Exit Password Manager'"

# Create vault.txt if it doesn't exist
touch vault.txt
chmod 600 vault.txt

# 'While' loop presents main_menu and evaluates user input
# User input 1, 2, or 3 will confirm the user's selection, carry out the appropriate action, then reset to option selection
# User input 4 will exit the program
while True; do
	eval $main_menu #Present main_menu
	read -p "Enter your choice: " choice #Get input from user. 
	choice_message="You have selected:" # Placeholder message stored in variable to be concatenated during case statement
	echo "------------------------------"
	echo
	case $choice in
        1) 
		# Choice 1. Create or update an entry. 
		choice_message="$choice_message 'Create or update an entry'"
		echo $choice_message
		read -p "Enter the name of the service for which to store/update a password: " service # User prompted for service name
		echo
		existing_entry=$(awk -v serv="$service" '$2 == serv {print  $0}' vault.txt) # vault.txt searched to see if service already has an entry
		if [ -n "$existing_entry" ]; then
		# if an entry already exists for that service the user is prompted to update the service
			while True; do
				read -p "Password entry already exists for $service. Would you like to update this entry? [y/n]: " choice
				echo
				if [ "$choice" = "y" ]; then
				# if the user chooses to update then they are prompted for new username and password details which are updated in vault.txt
					read -p "Enter the new username: " new_user
					read -p "Enter the new password: " new_pass
					awk -v serv="$service" -v user="$new_user" -v pass="$new_pass" '$2 == serv {$3=user; $4=pass} {print}' vault.txt > tmpfile && mv tmpfile vault.txt
					echo "Password updated successfully"
					echo "------------------------------"
					echo
					break
				elif [ "$choice" = 'n' ]; then
				# if the user chooses not to update they are returned to the main menu
					break
				else
				# if input is anything other than y or n an error is displayed and the user is prompted again
					echo "Invalid selection"
					echo "------------------------------"
					echo
				fi
			done
		else
			# If no entry is found for the given service a new entry is created
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
		# Choice 2. Views all entries or a single entry
		choice_message="$choice_message 'View entries'"
		echo "$choice_message"
		echo -e "Please select from the following options:\n1. View all entries\n2. View a single entry"
		read -p "Option: " choice
		echo
		while True; do
			if [ "$choice" = "1" ]; then
			# If user selects option 1 all entries in vault.txt are displayed in a tabular format
				echo -e "ID\tService\tUsername\tPassword\n$(cat vault.txt)" | column -t
				echo "------------------------------"
				echo
				break
			elif [ "$choice" = "2" ]; then
			# If user selects option 2 then they are prompted to enter a service name 
				read -p "Enter the name of the service to be viewed: " service
				echo
				requested_credentials=$(awk -v serv="$service" '$2 == serv {print $0}' vault.txt) # Retrieve both username and password from vault.txt in a single awk command
				requested_username=$(echo "$requested_credentials" | awk '{print $3}')
				requested_password=$(echo "$requested_credentials" | awk '{print $4}')
				if [ -n "$requested_username" ] && [ -n "$requested_password" ]; then
				# If the service has an entry in vault.txt the suername and password are displayed
					echo "The username for $service is: $requested_username"
					echo "The password for $service is: $requested_password"
					echo "------------------------------"
					echo
					break
				else
				# If there is no entry in vault.txt a message is displayed and the user returns to the main menu
					echo "Service $service not found in the password vault."
					echo "------------------------------"
					echo
					break
				fi
			else
				# If the user enters anything except 1 or 2 they are prompted to try again
				echo "Invalid selection"
				echo "------------------------------"
				echo
			fi
		done
		;;

		3) 
		# Choice 3. Deletes a single entry or all entries
		choice_message="$choice_message 'Delete entry'"
		echo $choice_message
		echo -e "Please select from the following main_menu:\n1. Delete a single entry\n2. Delete all entries"
		read -p "Option: " choice
		echo
		while True; do
			if [ "$choice" = "1" ]; then
			# If user selects option 1 they are prompted to give the name of the service to be deleted
				read -p "Enter the name of the service to be deleted: " service
				echo
				requested_deletion_line=$(awk -v serv="$service" '$2 == serv {print NR}' vault.txt)
				if [ -n "$requested_deletion_line" ]; then
				# if the service has an entry in vault.txt the user will be prompted to confirm before it is deleted
					read -p "The entry for $service will be permanently deleted. Are you sure? [y/n]: " confirm
					if [ "$confirm" = "y" ]; then
					# Once the user has confirmed the deletion the line will be deleted
						sed -i .temp "${requested_deletion_line}d" vault.txt ; rm vault.txt.temp 
						# sed creates a copy of vault.txt with the requested line removed called vault.txt.temp. the contents of vault.txt are then replaced
						# by the contents of vault.txt.temp. rm command then deletes vault.txt.temp file after it is no longer needed
						echo "The password for $service has been deleted."
						echo "------------------------------"
						echo
						break
					elif [ "$confirm" = "n" ]; then
					# If the user cancels the deletion they are returned to the main menu
						echo "Delete action cancelled"
						echo "------------------------------"
						echo
						break
					else
					# If the user enters anything except y or n they are prompted to try again
					echo "Invalid selection"
					echo "------------------------------"
					echo
					fi
				else
					echo "Service $service not found in the password vault."
					echo "------------------------------"
					echo
					break
				fi
			elif [ "$choice" = "2" ]; then
			# If user selects option 2 they will be asked to confirm before all entries are deleted
				read -p "All entries will be permanently deleted. Are you sure? [y/n]: " confirm
				echo
				if [ "$confirm" = "y" ]; then
				# If confirmed all entries are deleted
					$(> vault.txt)
					echo "All entries deleted succesfully"
					echo "------------------------------"
					echo
					break
				elif [ "$confirm" = "n" ]; then
				# If the user cancels the deletion they are returned to the main menu
					echo "Delete action cancelled"
					echo "------------------------------"
					echo
					break
				else
				# If the user enters anything except y or n they are prompted to try again
					echo "Invalid selection"
					echo "------------------------------"
					echo
				fi
			else
			# If the user enters anything except 1 or 2 they are prompted to try again
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
		# All invalid inputs will display an error message and loop will reiterate, reprompting the user and displaying main_menu
		echo "Invalid choice. Please try again"; echo ; echo "------------------------------"; echo
	esac
done

