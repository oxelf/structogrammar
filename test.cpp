#include <cstdlib>
#include <fstream>
#include <iostream>

void generate() {
  std::string email, description, username, password;
  int id;
  std::cout << "Enter username: ";
  std::cin >> username;
  std::cout << "Enter E-Mail: ";
  std::cin >> email;
  std::ofstream Passwords("Passwords.txt", std::ios::app);
  Passwords << "'" << "" << "' '" << password << "'" << std::endl;
  Passwords.close();
  std::cout << "Password generated";
  system("pause");
}

int main() {
  std::string password;
  std::ifstream Password("Password.txt");
  Password >> password;
  if (password == "") {
    firstLaunch();
  }
  login();
  mainmenu();
}
