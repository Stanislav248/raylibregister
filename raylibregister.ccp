#include "raylib.h"
#include <string>
#include <vector>

class User {
public:
    std::string email;
    std::string password;
    std::string name;
    int age;
    std::string salt;

    User(std::string e, std::string p, std::string n, int a) {
        email = e;
        name = n;
        age = a;
        salt = std::to_string(GetRandomValue(1000, 9999));
        password = hashPassword(p, salt);
    }

    static std::string hashPassword(std::string pass, std::string s) {
        unsigned long hash = 5381;
        std::string combined = pass + s;
        for (char c : combined) hash = ((hash << 5) + hash) + c;
        return std::to_string(hash);
    }
};

int main() {
    InitWindow(400, 400, "Auth");

    std::vector<User> users;
    char inputEmail[32] = "test@mail.com";
    char inputPass[32] = "1234";
    std::string status = "Press R to Reg, L to Login";

    while (!WindowShouldClose()) {
        if (IsKeyPressed(KEY_R)) {
            users.push_back(User(inputEmail, inputPass, "User1", 20));
            status = "Registered!";
        }

        if (IsKeyPressed(KEY_L)) {
            bool found = false;
            for (const auto& u : users) {
                if (u.email == inputEmail && u.password == User::hashPassword(inputPass, u.salt)) {
                    status = "Success: Hello " + u.name;
                    found = true;
                    break;
                }
            }
            if (!found) status = "Login Failed!";
        }

        BeginDrawing();
        ClearBackground(RAYWHITE);
        DrawText(status.c_str(), 20, 200, 20, DARKGRAY);
        DrawText("Email: test@mail.com", 20, 50, 10, GRAY);
        DrawText("Pass: 1234", 20, 70, 10, GRAY);
        EndDrawing();
    }
    CloseWindow();
}
