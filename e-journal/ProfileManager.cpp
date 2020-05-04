#include "ProfileManager.h"

ProfileManager::ProfileManager()
    : m_db_teachers{ new DBProvider(Teachers) },
      m_db_users{ new DBProvider(Users) }
{

}

ProfileManager::~ProfileManager() {
    delete(m_db_users);
    delete(m_db_teachers);
}

bool ProfileManager::createNewUser(const QString &login,
                                   const QString &password,
                                   const QString &name) {

    if (login.length() <= 4 || password.length() <= 4)
        return false;

    std::vector user_columns = {
        QString("username")
    };

    if (m_db_users->select(user_columns)->where(login)->exist())
        return false;

    bool state{ false };
    user_columns.push_back(QString("password"));

    HashHelper hHelper(password);

    std::vector user_values = {
        login,
        hHelper.hash()
    };

    state = m_db_users->insert(user_columns)
                      ->values(user_values)
                      ->exec();

    if (state) {
        std::vector teachers_values = {
            QString("full_name=%1").arg(name)
        };
        int id_user = m_db_users->last_id();

        state = m_db_teachers->update(teachers_values)
                             ->where(QString("id_user=%1").arg(QString::number(id_user)))
                             ->exec();
        // Если не получиться добавить, то ошибка
        if (!state) {
            qDebug() << m_db_teachers->query().lastError();
            m_db_users->delete_from()->where(QString("id=%1").arg(id_user))->exec();
        }
    }

    return state;
}

bool ProfileManager::deleteUser(const QString &login, const QString &password)
{
    if (login <= 4 || password <= 4)
        return false;

    std::vector tables = {
        QString("username"),
        QString("password")
    };

    bool status{ false };

    HashHelper hHelper(password);
    QString condition = QString("username=%1 AND password=%2")
                        .arg(login).arg(hHelper.hash());

    if (m_db_users->select(tables)
                  ->where(condition)
                  ->exist()) {

        status = m_db_users->delete_from()
                           ->where(condition)
                           ->exec();
    }

    return status;
}

bool ProfileManager::changePassword(const QString &login, const QString &newPassword)
{
    if (login <= 4 || newPassword <= 4)
        return false;

    std::vector user_columns = {
        QString("username")
    };

    const QString condition = QString("username=%1").arg(login);
    bool status{ false };
    if (m_db_users->select(user_columns)
            ->where(condition)
            ->exist()) {
        status = m_db_users->delete_from()->where(condition)->exec();
    }

    return status;
}

//Maybe it works incorrect
QString ProfileManager::userLogin(const QString &password, const QString &name)
{
    if (password <= 4)
        return QString{ "Sorry, but Your password lenght less than 4!" };

    if (name.isEmpty() || name.isNull())
        return QString{ "Who are you? I don't klow you..." };

    int id_user{ -1 };
    QString full_name{ "Ops! Something is incorrect." };
    QString condition = QString("full_name LIKE '%1' ").arg('%' + name + '%');


    if (m_db_teachers->select_all()
                     ->where(condition)
                     ->exist()) {
        std::vector teachers_columns = {
            QString("id_user"),
        };

        m_db_teachers->select(teachers_columns)
                     ->where(condition)
                     ->exec();

        id_user = m_db_teachers->query().value(0).toInt();
    }

    HashHelper hHelper(password);

    condition = QString("password='%1' AND id=%2").arg(hHelper.hash()).arg(id_user);

    if(m_db_users->select_all()->where(condition)->exist()) {
        std::vector teachers_columns = {
            QString("full_name"),
        };

        m_db_teachers->select(teachers_columns)
                     ->where(condition)
                     ->exec();

        full_name = m_db_teachers->query().value(0).toString();
    }

    return full_name;
}
