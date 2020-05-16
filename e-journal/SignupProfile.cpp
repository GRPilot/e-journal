#include "SignupProfile.h"

SignupProfile::SignupProfile(QObject *parent)
    : QObject{ parent },
      m_manager{ new ProfileManager() }
{}

SignupProfile::SignupProfile(const SignupProfile &other)
    : SignupProfile(other.parent())
{}

SignupProfile::~SignupProfile() {
    delete m_manager;
}

bool SignupProfile::newUser(const QString &login,
                            const QString &password,
                            const QString &name) {
    bool status{ false };

    status = m_manager->createNewUser(login, password);

    if (status)
        status = m_manager->setUserName(login, name);

    return false;
}

bool SignupProfile::checkUser(const QString& login)
{
    if (login.isEmpty())
        return false;

    return m_manager->checkUser(login);
}
