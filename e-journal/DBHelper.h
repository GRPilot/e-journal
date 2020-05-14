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
    using Val_List = std::vector<QString>;

 public:
    DBHelper(const Tables table);

    DBHelper &select_all();
    DBHelper &select(Val_List columns);
    DBHelper &insert();
    DBHelper &insert(Val_List columns);
    DBHelper &update(Val_List values);
    DBHelper &delete_from();

    DBHelper &where(const QString condition);
    DBHelper &values(Val_List values);

    void exist();
    int  last_id();
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

    QString valListToQString(Val_List vals) const;
};
