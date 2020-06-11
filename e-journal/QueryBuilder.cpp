#include "QueryBuilder.h"

QueryBuilder::QueryBuilder(const Tables table)
    : m_nameOfDB{ "e-journal-database" },
      m_path{ QDir::currentPath() + '/' + m_nameOfDB },
      m_currentTable{ table }
{}

QueryBuilder &QueryBuilder::select_all() {
    return select("*");
}

QueryBuilder& QueryBuilder::select(const QString& column)
{
    if (column.isEmpty())
        return this->select_all();

    QString curTabel = currentTable();

    m_query = QString("SELECT %1 FROM %2 ")
              .arg(column).arg(curTabel);

    return *this;
}

QueryBuilder &QueryBuilder::select(Values_t columns) {
    if (columns.empty())
        return *this;

    QString cols = valuesToQString(columns);

    return this->select(cols);
}

QueryBuilder &QueryBuilder::insert() {
    m_query = QString("INSERT INTO %1 ")
              .arg(currentTable());

    return *this;
}

QueryBuilder& QueryBuilder::insert(const QString& column) {
    if (column.isEmpty())
        return this->insert();

    QString curTabel = currentTable();

    m_query = QString("INSERT INTO %1(%2) ")
              .arg(curTabel).arg(column);

    return *this;
}

QueryBuilder &QueryBuilder::insert(Values_t columns) {
    if (columns.empty())
        return this->insert();

    QString cols = valuesToQString(columns);

    return this->insert(cols);
}

QueryBuilder& QueryBuilder::update(const QString& value)
{
    if (value.isEmpty())
        return *this;

    QString curTabel = currentTable();

    m_query = QString("UPDATE %1 SET %2 ")
              .arg(curTabel).arg(value);

    return *this;
}

QueryBuilder &QueryBuilder::update(Values_t values) {
    if (values.empty())
        return *this;

    QString vals = valuesToQString(values);

    return this->update(vals);
}

QueryBuilder &QueryBuilder::delete_from() {
    m_query = QString{"DELETE FROM %1 "}
              .arg(currentTable());

    return *this;
}

QueryBuilder& QueryBuilder::inner_join_on(const QString& tablename,
                                          const QString& onCondition)
{
    if (tablename.isEmpty())
        return *this;

    m_query.append(QString{" INNER JOIN %1 ON %2 "}
                   .arg(tablename).arg(onCondition));

    return *this;
}

QueryBuilder& QueryBuilder::where(const QString& condition) {
    if (condition.isEmpty() || condition.isNull())
        return *this;

    if (m_query.isEmpty() || m_query.isNull())
        return *this;


    m_query.append(QString("WHERE %2")
                   .arg(condition));
    return *this;
}

QueryBuilder &QueryBuilder::values(Values_t values) {
    if (values.empty() || m_query.isEmpty() || m_query.isNull())
        return *this;

    if (!m_query.contains("INSERT INTO"))
        return *this;

    QString vals = valuesToQString(values);

    m_query.append(QString("VALUES (%2) ")
                   .arg(vals));

    return *this;
}

void QueryBuilder::exist() {
    if (!m_query.contains("SELECT"))
        return;

    m_query.prepend("SELECT EXISTS (");
    m_query.append(")");
}

void QueryBuilder::clearQuery()  {
    m_query.clear();
}

QString QueryBuilder::currentTable() const {
    switch (m_currentTable) {
    case Tables::Groups:
        return QString("groups");
    case Tables::Marks:
        return QString("marks");
    case Tables::Students:
        return QString("students");
    case Tables::Subjects:
        return QString("students");
    case Tables::Teachers:
        return QString("teachers");
    case Tables::Users:
        return QString("users");

    default:
        return {};
    }
}


QString QueryBuilder::valuesToQString(Values_t vals) const {
    QString result{""};
    if (vals.empty())
        return result;

    if (vals.size() == 1)
        return vals.front();

    for (auto&& val : vals) {
        result += QString("%1").arg(val);
        result += val != vals.back() ? ", " : "";
    }

    return result;
}

QString QueryBuilder::query() const {
    return m_query;
}

void QueryBuilder::setQuery(const QString& query) {
    if (!query.isEmpty())
        m_query = query;

}

QString QueryBuilder::path() const {
    return m_path;
}
