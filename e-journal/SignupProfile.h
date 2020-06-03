/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * SignupProfile - связующий класс между логикой работы с базой данных и       *
 * и окном регистрации нового пользователя.                                    *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#pragma once

#include <QObject>
#include "ProfileManager.h"

class SignupProfile : public QObject
{
    Q_OBJECT

 public:
    SignupProfile(QObject *parent = nullptr);
    SignupProfile(const SignupProfile &other) = delete;
    ~SignupProfile();

    SignupProfile& operator=(const SignupProfile other) = delete;

    /// Создать нового пользователя
    Q_INVOKABLE bool newUser(const QString& login,
                             const QString& password,
                             const QString& name = "username");

    /// Проверить логин на наличае в базе данных
    Q_INVOKABLE bool checkUser(const QString& login);

 private:
    ProfileManager *m_manager;
};

