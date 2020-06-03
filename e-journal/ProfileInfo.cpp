#include "ProfileInfo.h"

ProfileInfo::ProfileInfo(QObject *parent)
    : QObject(parent)
    , m_name    { "<username>"   }
    , m_subjects{ "<no items>"   }
    , m_groups  { "<no items>"   }
    , m_image   { ":/imgs/user"  }
{}

ProfileInfo::ProfileInfo(const QString& username, QObject* parent)
    : ProfileInfo(parent)
{
    if(!setUsername(username))
        qDebug() << "Error! Cannot get user info!";
}

QString ProfileInfo::name() const {
    return m_name;
}

QString ProfileInfo::subjects() const {
    return stringsToString(m_subjects);
}

QString ProfileInfo::groups() const {
    return stringsToString(m_groups);
}

QImage ProfileInfo::image() const {
    return m_image.toImage();
}

bool ProfileInfo::setUsername(const QString& username) {
    using profile_t = ProfileData::Profile_type;

    if (username.isEmpty())
        return false;


    ProfileData data{ username.toLower() };
    profile_t curProfile{ data.currentProfile() };

    m_name     = curProfile.mName;
    m_subjects = curProfile.mSubjects;
    m_groups   = curProfile.mGroups;
    m_image    = curProfile.mProfileImg;

    return true;
}

QString ProfileInfo::stringsToString(const ProfileInfo::Strings& strings) const {
    if (strings.size() == 1)
        return strings.back();

    if (auto size{strings.size()}; size >= 2) {
        QString outstr;

        for (unsigned count{}; count < size; ++count) {
            if (count != size - 1)
                outstr.append("%").append(QString::number(count + 1)).append(", ");
            else
                outstr.append("%").append(QString::number(count + 1));
        }

        for (auto item : strings)
            outstr = outstr.arg(item);

        return outstr;
    }

    return QString{"<no items>"};
}
