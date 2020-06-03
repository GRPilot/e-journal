#include "AuthValidator.h"

AuthValidator::AuthValidator(QObject *parent)
    : QObject(parent),
      m_manager{ new ProfileManager() }
{}

AuthValidator::AuthValidator(const AuthValidator &other)
    : AuthValidator{ other.parent() } {}

AuthValidator::~AuthValidator() {
    delete m_manager;
}

bool AuthValidator::checkPassWithUser(const QString& login,
                                      const QString& password)
{
    if (login.isEmpty() || login.isNull()) {
        return false;
    }

    // checkPassAndUser возвращает true при успешном
    // совпадении login и password с данными из бд
    return m_manager->checkPassAndUser(login, password);
}

bool AuthValidator::checkUser(const QString& username)
{
    if (username.isNull() || username.isEmpty()) {
        return false;
    }

    // checkUser возвращает true при наличае username в бд
    return m_manager->checkUser(username);
}


