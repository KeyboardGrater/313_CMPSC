#include <stdio.h>
#include <stdlib.h>

typedef struct {
    unsigned int account_number;
    double annual_interest_rate;
    double savings_balance;
} SavingsAccount;

SavingsAccount * new_account (unsigned int account_number, double annual_interest_rate, double savings_balance) {
    // Allocate memory
    SavingsAccount * new_account = (SavingsAccount *) malloc (sizeof(SavingsAccount));

    // Fill in the values
    new_account->account_number = account_number;
    new_account->annual_interest_rate = annual_interest_rate;
    new_account->savings_balance = savings_balance;
}

void print_balance (SavingsAccount * account) {
    double balance;

    balance = account->savings_balance;

    printf("New Balance: ");
    printf("%lf", balance); 
    printf("\n");
}

void calculate_monthly_interest (SavingsAccount * account) {
    double interest;
    double balance;
    double annual_interest_rate;
    double monthly_interest;

    annual_interest_rate = account->annual_interest_rate;
    balance = account->savings_balance;

    interest = annual_interest_rate * balance;

    monthly_interest = interest / 12;

    balance = balance + monthly_interest;

    account->savings_balance = balance;

    // Call printBalance
    print_balance(account);
} 

void set_interest_rate (SavingsAccount * account, double annual_interest_rate) {
    account->annual_interest_rate = annual_interest_rate;
}

int main () {
    // Declare Accounts and call constructor
    SavingsAccount * account_1 = new_account(1, 0.03, 2000.00);
    SavingsAccount * account_2 = new_account(2, 0.03, 3000.00);

    // Calculate monthly interest
    calculate_monthly_interest(account_1);
    calculate_monthly_interest(account_2);

    // Change annual interest rate 
    set_interest_rate(account_1, 0.04);
    set_interest_rate(account_2, 0.04);

    // Print the new balance
    calculate_monthly_interest(account_1);
    calculate_monthly_interest(account_2);

    return 0;
}