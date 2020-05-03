#ifndef DBPROVIDER_H
#define DBPROVIDER_H

//#include <QtSql/QSqlDatabase>
//#include <QtSql/QSqlQuery>

#include <QtSql>


enum Tables {
    Groups = 0,
    Marks,
    Students,
    Subjects,
    Teachers,
    Users
};

class DBProvider
{
    using Val_List = std::vector<QString>;

 public:
    DBProvider(const Tables table);

    DBProvider* select();
    DBProvider* select(Val_List columns);
    DBProvider* insert();
    DBProvider* insert(Val_List columns);
    DBProvider* update(Val_List values);
    DBProvider* delete_from();

    DBProvider* where(const QString condition);
    DBProvider* values(Val_List values);

    bool exist();
    bool exec();
    int last_id();
    void clearQuery();

    QString currentTabel() const;
    QString buildingQuery() const;

    QSqlQuery query() const;

private:
    const QString m_nameOfDB;
    const Tables  m_currentTabel;
    QSqlDatabase  m_dbase;
    QSqlQuery     m_query;
    QString       m_buildingQuery;

    QString valListToQString(Val_List vals);
};

#endif // DBPROVIDER_H
