#pragma once

#include <QString>
#include <QDir>
#include <vector>

enum Tables {
    Groups = 0,
    Marks,
    Students,
    Subjects,
    Teachers,
    Users
};

class DBHelper
{
    using Values_t = std::vector<QString>;

 public:
    DBHelper(const Tables table);

    DBHelper &select_all();
    DBHelper &select(Values_t columns);
    DBHelper &insert();
    DBHelper &insert(Values_t columns);
    DBHelper &update(Values_t values);
    DBHelper &delete_from();

    DBHelper &where(const QString condition);
    DBHelper &values(Values_t values);

    void exist();
    void clearQuery();

    QString currentTabel() const;
    QString path() const;
    QString query() const;
    void setQuery(const QString& query);


private:
    const QString m_nameOfDB;
    const QString m_path;
    const Tables  m_currentTabel;
    QString       m_query;

    QString valuesToQString(Values_t vals) const;
};
