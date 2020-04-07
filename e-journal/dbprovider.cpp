#include "dbprovider.h"

DBProvider::DBProvider(const Tables table)
    : m_PathToDB{ "/e-journal-database" },
      m_currentTabel{ table }
{
    m_dbase = QSqlDatabase::addDatabase("QSQLITE");
    m_dbase.setDatabaseName(m_PathToDB);

    if (!m_dbase.open()) {
        qDebug() << m_dbase.lastError().text();
        throw m_dbase.lastError();
    }
}

DBProvider *DBProvider::select(const QString columns)
{
    if (columns.isEmpty() || columns.isNull())
        return this;

    m_buildingQuery = QString("SELECT %1 FROM %2 ")
            .arg(columns)
            .arg(currentTabel());

    return this;
}

DBProvider *DBProvider::insert()
{
    m_buildingQuery = QString("INSERT INTO %1 ").arg(currentTabel());
    return this;
}

DBProvider *DBProvider::where(const QString condition)
{
    if (condition.isEmpty() || condition.isNull())
        return this;

    if (m_buildingQuery.isEmpty() || m_buildingQuery.isNull())
        return nullptr;

    m_buildingQuery += QString("WHERE %1").arg(condition);
    return this;
}

DBProvider *DBProvider::values(const std::vector<QString> values_list)
{
    if (values_list.empty() || m_buildingQuery.isEmpty() || m_buildingQuery.isNull())
        return this;

    if (!m_buildingQuery.contains("INSERT INTO"))
        return this;

    m_buildingQuery += "VALUES (";
    for (auto&& val : values_list) {
        m_buildingQuery += QString("'%1', ").arg(val);
    }
    m_buildingQuery[m_buildingQuery.size() - 1] = ')';

    return this;
}

bool DBProvider::exec()//QString query = m_buildingQuery)
{
    QString buildQuery = buildingQuery();
    if (buildQuery.isEmpty() || buildQuery.isNull())
        return false;

    if (query().isNull(buildQuery) || !query().isValid())
        return false;

    return query().exec();
}

QSqlQuery DBProvider::query() const {
    return m_query;
}

QString DBProvider::currentTabel() const
{
    switch (m_currentTabel) {
    case Tables::USERS:
        return static_cast<QString>("users");
    case Tables::TEACHERS:
        return static_cast<QString>("teachers");
    case Tables::STUDENTS:
        return static_cast<QString>("students");
    case Tables::MARKS:
        return static_cast<QString>("marks");
    default:
        return {};
    }
}

QString DBProvider::buildingQuery() const {
    return m_buildingQuery;
}
