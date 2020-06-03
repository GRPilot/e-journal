/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * ProfileManager был создан с целью объединить все действия, связанные с      *
 * доступом и управлением частью бд, которая ответственна за пользователей.    *
 *                                                                             *
 * Соответственно здесь реализованы следующие методы:                          *
 *      + методы добавления и удаления пользователей;                          *
 *      + проверка никнейма на наличие в бд;                                   *
 *      + проверка соответствия логина и пароля;                               *
 *      + метод изменение инициалов пользователя по никнейму;                  *
 *                                                                             *
 * В будущем данный класс будет дополняться по мере необходимости.             *
 * Главная идея класса состоит в декомпозиции с классами, которые являются     *
 * ключевым звеном при взаимодействии с qml компонентами, тем самым отделяя    *
 * логику взаимодействия с базой данных и обработкой пользовательского ввода.  *
 *                                                                             *
 * QueryBuilder необходим для упрощения составления запросов к базе данных.    *
 * HashHelper необходим для упращенного хэширования паролей                    *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#pragma once

#include "QueryBuilder.h"
#include "HashHelper.h"
#include <QtSql>

class ProfileManager {
    // Ограничение на ввод логина или пароля, состоящих менее чем из 4 символов
    const int c_minLenght{ 4 };

 public:
    ProfileManager();

    /// Создание нового пользователя
    bool createNewUser(const QString &username, const QString &password);
    /// Удаление пользователя
    bool deleteUser   (const QString &username, const QString &password);

    /// Проверка наличия никнейма в базе данных
    bool checkUser       (const QString &username);
    /// Проверка никнейма и пароля на наличие в базе данных
    bool checkPassAndUser(const QString& username, const QString& password);

    /// Изменение инициалов пользователя по логину
    bool setUserName(const QString &username, const QString& newName);

 private:
    QueryBuilder m_queryTeachersBuilder;
    QueryBuilder m_queryUsersBuilder;

    /// Выполнить запрос (query) для базы данных (pathToDatabase).
    /// При успешном выполнении (даже при пустом ответе) возвращает true
    bool exec     (const QString& query, const QString& pathToDatabase);
    /// Выполняет запрос с учетом ответа
    bool exsist   (const QString& query, const QString& pathToDatabase);
    int  getUserID(const QString& username);
};
