
import 'dart:io';

class BankAccount{

  static int idsGenerator=0;
  late int accountId;
  late double balance;
  late Client ownerAccount;

  // primary constructor

  BankAccount({required this.balance})
  {
    accountId=idsGenerator;
    idsGenerator++;
  }

  // named constructor

  BankAccount.init(){
    balance=0.0;
    accountId=idsGenerator;
    idsGenerator++;
  }

  // functions

  bool withdraw(double amount)
  {
    if( balance <=0)
    {
      print("invalid amount !");
      return false;
    }
    else if(balance<amount)
    {
      print("the balance is not sufficient to complete withdraw !");
      return false;
    }
    else
    {
      balance-=amount;
      return true;
    }
  }

  bool deposite( double amount )
  {
    if( amount < 0)
    {
      print("the amount is not valid !");
      return false;
    }
    else {
      balance += amount;
      return true;
    }
  }

  void view()
  {
    print("BankAccount ");
    print(" accountId = $accountId");
    print(" balance = $balance");
    ownerAccount.view();

  }

}

// class SavingsBankAccount

class SavingsBankAccount extends BankAccount
{
  late double minBalance;

  // primary constructor
  SavingsBankAccount({required double balance , this.minBalance=1000}): super(balance: balance);

  // functions

  @override
  bool withdraw(double amount) {

    if((balance-amount)<minBalance)
    {
      print(" invalid amount!");
      return false;
    }
    else if (amount < balance && (balance-amount)>minBalance)
    {
      balance-=amount;
      return true;
    }
    else
    {
      return super.withdraw(amount);
    }
  }

  @override
  bool deposite(double amount) {

    if(amount < 100)
    {
      print("the amount invalid !");
      return false;
    }
    else
    {
      return super.deposite(amount);
    }

  }

  @override
  void view() {
    print("Saving bank account !");
    super.view();
  }

}

// class client

class Client
{
  late String name ;
  late String address;
  late String phoneNumber;
  late BankAccount clientAccount;


  //primary constructor

  Client({required this.name,required this.address,
    required this.phoneNumber});

  void view ()
  {
    print("name = $name");
    print("address = $address");
    print("phoneNumber = $phoneNumber");

  }


}

class BankingSystem {
  late List<BankAccount> accountList;
  late List<Client> clientList;

  BankingSystem() {
    accountList = [];
    clientList = [];
    addTestData();
  }


  void addTestData() {
    for (int i = 1; i <= 20; i++) {
      Client client = Client(name: "Client $i",
          address: "address $i",
          phoneNumber: "phoneNumber $i");
      BankAccount bankAccount = BankAccount(balance: i * 10000);
      client.clientAccount = bankAccount;
      bankAccount.ownerAccount = client;

      accountList.add(bankAccount);
      clientList.add(client);
    }
  }


  void showMenu() {
    print("1- create account !");
    print("2- show all account !");
    print("3- show account details !");
    print("4- delete account !");
    print("5- withdraw !");
    print("6- deposite !");
    print("7- exit !");

    while (true) {
      print("please enter your choice !");
      int input = int.parse(stdin.readLineSync()!);
      if (input == 1) {

        stdout.write("Enter client name: ");
        String name = stdin.readLineSync()!;
        stdout.write("Enter client address: ");
        String address = stdin.readLineSync()!;
        stdout.write("Enter client phone: ");
        String phone = stdin.readLineSync()!;
        Client client=Client(name: name, address: address, phoneNumber: phone);

        stdout.write("Enter initial balance: ");
        double balance = double.parse(stdin.readLineSync()!);
        BankAccount account;

        stdout.write("Is it a savings account? (y/n): ");
        String choice = stdin.readLineSync()!.toLowerCase();




        if (choice == "y") {
          stdout.write("Enter minimum balance for savings account: ");
          double minBalance = double.parse(stdin.readLineSync()!);
          account = SavingsBankAccount(balance: balance, minBalance: minBalance);
        } else {
          account = BankAccount(balance: balance);
        }

        client.clientAccount=account;
        account.ownerAccount=client;

        clientList.add(client);
        accountList.add(account);
        print("✅ Account created successfully!");

      }
      else if (input == 2) {
        showAllAccounts();
      }
      else if (input == 3) {
        showAccountDetails();
      }
      else if (input == 4) {
        deleteAccount();
      }
      else if (input == 5) {
        withdraw();
      }
      else if (input == 6) {
        deposite();

      }
      else if (input == 7) {
        break;
        return;
      }
    }
  }

  int searchByAccountId(accountId) {
    for (int i = 0; i <= accountList.length; i++) {
      if (accountId == accountList[i].accountId) {
        print(" this account is exist");
        return i;
      }
    }
    return -1;
  }

  BankAccount? searchByAccount(int accountId) {
    for (int i = 0; i <= accountList.length; i++) {
      if (accountId == accountList[i].accountId) {
        print(" this account is exist");
        return accountList[i];
      }
    }
    return null;
  }


  void showAccountDetails() {
    print("please enter accountID");
    int accountId = int.parse(stdin.readLineSync()!);
    int index = searchByAccountId(accountId);

    if (index == -1) {
      print("this account not valid");
      return;
    }
    else {
      accountList[index].view();
    }
  }

  void showAllAccounts() {
    for (int i = 0; i < clientList.length; i++) {
      accountList[i].view();
      print("-------------------------------------------");
    }
  }


  void deleteAccount() {
    print("enter accountid that need to delete");
    int accountId = int.parse(stdin.readLineSync()!);
    int accountDeleted = searchByAccountId(accountId);
    if (accountDeleted == -1) {
      print("this account not valid");
      return;
    }
    else {
      accountList.removeAt(accountDeleted);
      clientList.removeAt(accountDeleted);
      print("deleted account successfully !");
    }
  }


  void withdraw() {
    print("please enter accountID");
    int accountId = int.parse(stdin.readLineSync()!);
    int index = searchByAccountId(accountId);
    if (index == -1) {
      print("this account not valid");
      return;
    }
    else
    {
      print("enter amount");
      double amount=double.parse(stdin.readLineSync()!);
      if( accountList[index].withdraw(amount)== true)
      {
        print("successful transaction");
      }
    }
  }



  void deposite() {

    print("please enter accountID");
    int accountId = int.parse(stdin.readLineSync()!);
    int index = searchByAccountId(accountId);
    if (index == -1) {
      print("this account not valid");
      return;
    }
    else
    {
      print("enter amount");
      double amount=double.parse(stdin.readLineSync()!);
      if( accountList[index].deposite(amount)== true)
      {
        print("successful transaction");
      }
    }
  }
}

void main()
{

  BankingSystem bankingSystem=BankingSystem();
  bankingSystem.showMenu();

}

