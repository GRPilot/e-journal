/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Данный класс был создан исключительно для проведения вадидации пользователя *
 * и проверки существования никнейма в базе данных. Данный класс наследует     *
 * QObject для осуществления дальнейшей связи с qml кодом.                     *
 *                                                                             *
 * ProfileManager.h служит для доступа к базе данных и работе с методами.      *
 * Используя декомпозицию мы ограничиваем использование методов класса         *
 * ProfileManager, предоставляя только два метода:                             *
 *     ProfileManager::checkUser();                                            *
 *     ProfileManager::checkPassAndUser();                                     *
 *                                                                             *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#pragma once

#include <QObject>
#include "ProfileManager.h"

class AuthValidator : public QObject
{
    Q_OBJECT

 public:
    AuthValidator(QObject *parent = nullptr);
    AuthValidator(const AuthValidator& other);

    ~AuthValidator();

    Q_INVOKABLE bool checkPassWithUser(const QString& username,
                                       const QString& password);
    Q_INVOKABLE bool checkUser(const QString& username);

 private:
    ProfileManager *m_manager;
};

