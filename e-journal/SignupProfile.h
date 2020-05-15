#pragma once

#include <QObject>
#include "ProfileManager.h"

class SignupProfile : public QObject
{
    Q_OBJECT

 public:
    SignupProfile(QObject *parent = nullptr);
    SignupProfile(const SignupProfile &other);
    ~SignupProfile();

    Q_INVOKABLE bool newUser(const QString &login,
                             const QString &password,
                             const QString &name = "username");
    Q_INVOKABLE bool checkUser(const QString &login);
 private:
    ProfileManager *m_manager;
};

