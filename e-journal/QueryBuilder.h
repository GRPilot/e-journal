/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * QueryBuilder - класс помощник, который упрощает процесс создания SQД        *
 * запросов и улучшает читабельность кода.                                     *
 *                                                                             *
 * Идея использования данного метода заключается в составлении цепочек запросов*
 * builder.select_all().where("id=3")                                          *
 * Таким образом внутри объекта данного класса составляется нужный запрос      *
 *                                                                             *
 * Инициализировать объект можно предоставленными таблицами (Tables)           *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#pragma once

#include <QString>
#include <QDir>
#include <vector>

enum Tables {
    Groups,
    Marks,
    Students,
    Subjects,
    Teachers,
    Users
};

class QueryBuilder
{
    using Values_t = std::vector<QString>;

 public:
    QueryBuilder(const Tables table);

    QueryBuilder& select_all();
    QueryBuilder& select(const QString& column);
    QueryBuilder& select(Values_t columns);

    QueryBuilder& insert();
    QueryBuilder& insert(const QString& column);
    QueryBuilder& insert(Values_t columns);

    QueryBuilder& update(const QString& value);
    QueryBuilder& update(Values_t values);
    QueryBuilder& delete_from();


    QueryBuilder& inner_join_on(const QString& tablename,
                                const QString& onCondition);


    QueryBuilder& where(const QString& condition);
    QueryBuilder& values(Values_t values);

    void exist();
    void clearQuery();

    QString currentTable() const;
    QString path() const;
    QString query() const;
    void setQuery(const QString& query);

private:
    const QString m_nameOfDB;
    const QString m_path;
    const Tables  m_currentTable;
    QString       m_query;

    QString valuesToQString(Values_t vals) const;
};
