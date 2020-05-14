#include "authorizationvalidator.h"

AuthorizationValidator::AuthorizationValidator(QObject *parent)
    : QObject(parent),
      m_manager{ new ProfileManager() }
{}

AuthorizationValidator::AuthorizationValidator(const AuthorizationValidator &other)
    : AuthorizationValidator{ other.parent() } {}

AuthorizationValidator::~AuthorizationValidator() {
    delete m_manager;
}

bool AuthorizationValidator::checkPassWithUser(const QString& login, const QString& password)
{
    if (login.isEmpty() || login.isNull()) {
        return false;
    }

    if (password.size() < minimumLenghtForPasswords)
        return false;

    bool status{ m_manager->checkPassAndUser(login, password) };

    return status;
}

bool AuthorizationValidator::checkUser(const QString& username)
{
    if (username.isNull() || username.isEmpty()) {
        return false;
    }

    bool status{ m_manager->checkUser(username) };

    return status;
}


