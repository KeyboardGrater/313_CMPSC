#include <stdio.h>
#include <stdbool.h>

// Global Variables
enum {INTEGERSET_ARRAY_SIZE = 100};         // Size of array (0-99)


struct IntegerSet {
    int a[INTEGERSET_ARRAY_SIZE];
};

// Zeros out the array
void constructor (struct IntegerSet * set_pointer) {
    int i = 0;
    const unsigned int ARRAY_SIZE = INTEGERSET_ARRAY_SIZE;

    while (true) {
        if (i > ARRAY_SIZE) {
            break;
        }
        set_pointer -> a[i] = 0;
        i = i + 1;
    }
}

unsigned int which_array_to_modify () {
    unsigned int array_to_modify;

    // Ask the user which array would they like to modify.
    printf("Which array would you like to chose.\nFor array one enter 1, for array two, enter 2. And if you would like to go back, enter 3.\n"); 

    // Get user input for which array they would like to modify.
    scanf("%u", &array_to_modify);

    // Return the user input
    return array_to_modify;
}

void insert_element (struct IntegerSet * set_pointer) {
    const unsigned int ARRAY_SIZE = INTEGERSET_ARRAY_SIZE;
    unsigned int user_number;
    
    // Find what number the user would like to remove
    printf("What number (0 - 99) would you like to insert?\n");
    scanf("%u", &user_number);

    set_pointer -> a[user_number] = 1;

}

void delete_element (struct IntegerSet * set_pointer) {
    int i = 0;
    const unsigned int ARRAY_SIZE = INTEGERSET_ARRAY_SIZE;
    unsigned int user_number;

    // Find out what element needs to be deleted.
    printf("What number (0 - 99), would you like to delete.");
    scanf("%u", &user_number);
    
    // Loop over to find the element, then replace it with zero, then exit loop.
    while (true) {
        // Do deletion 
        set_pointer -> a[i] = 0;

        // Check if it can be exited, i.e. if we are at element and performed the deletion action.
        if (i == user_number) {break;}

        // Iterate
        i = i + 1;
    }
}


int main () {
    struct IntegerSet array_1;
    struct IntegerSet array_2;
    unsigned int operation_choice;
    unsigned int array_choice;


    // Fill in the arrays (Simulates the constructor)
    constructor(&array_1);
    constructor(&array_2);

    // Loop for options (1 = union, 2 = intersection, 3 = insert, 4 = delete, 5 = print_set, 6 = equals, 7 = exit)
    // 3,4,5 all need to ask if the user wants to ask for array 1 or array 2

    while (true) {
        // Get user input for what operation they want to do.
        printf("Please pick a operation to perform.\n1: Union of two sets\n2: Intersection of two sets\n3: Insertion on a set\n4: Deletion on a set\n5: Print a set\n6: Check to see if two sets are equal\n7: Exit\n\n");
        scanf("%u", &operation_choice);
        
        // Check for 7 (i.e. if user wants to exit loop)
        if (operation_choice == 7) {break;}

        // If option 1
        // TODO

        // If option 2
        // TODO

        // Insert
        if (operation_choice == 3) {
            array_choice = which_array_to_modify();
            
            while (true) {
                // Case 1, 2, and 3, will all make the operations menu appear again. 1 and 2 does a action beforehand, where 3 skips that action.
                // The default case (when not 1, 2, nor 3) it repeates the array_choice. Still within insert element action choice.
                switch (array_choice) {
                    case 1:
                        insert_element(&array_1);
                        goto repeat_operation_choice;
                    case 2:
                        insert_element(&array_2);
                        goto repeat_operation_choice;
                    case 3:
                        goto repeat_operation_choice;
                    default:
                        break;
                }
            }
        }

        // Delete
        else if (operation_choice == 4) {
            array_choice = which_array_to_modify();

            while (true) {
                // Case 1, 2, 3, will all make the operations menu appear again. 1 and 2 does a action beforehand, where 3 skips that action.
                // The default case (when not 1, 2, nor 3) it repeates the array_choice. Still within insert element action choice.
                switch (array_choice) {
                    case 1:
                        delete_element(&array_1);
                        goto repeat_operation_choice;
                    case 2:
                        delete_element(&array_2);
                        goto repeat_operation_choice;
                    case 3:
                        goto repeat_operation_choice;
                    default:
                        break;
                }
            }
        }

        // (5) Print Set
        // TODO

        // (6) Equality Check
            // Make sure to check if the either set has been modified, maybe?
        // TODO

        
        
        repeat_operation_choice:
    }

    printf("Tester");


    return 0;
}

// Test Trials

// For Insert, Delete: Input these number:
// Ones that will work: 0,1, 50, 98, 99 => (min),(min + 1), (max/2), (max - 1), (max)
// Ones that won't work: -1, -2, -99, 100, 101, 200
