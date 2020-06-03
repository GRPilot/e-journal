#include "SignupProfile.h"

SignupProfile::SignupProfile(QObject *parent)
    : QObject{ parent },
      m_manager{ new ProfileManager() }
{}

SignupProfile::~SignupProfile() {
    delete m_manager;
}

bool SignupProfile::newUser(const QString& login,
                            const QString& password,
                            const QString& name) {

    if (!m_manager->createNewUser(login, password))
        return false;

    if (!m_manager->setUserName(login, name))
        return false;

    return true;
}

bool SignupProfile::checkUser(const QString& login)
{
    if (login.isEmpty())
        return false;

    return m_manager->checkUser(login);
}
