#include <iostream>

#include "lifxlightsmodel.h"

LIFXLightsModel::LIFXLightsModel(QObject *parent) :
    QAbstractListModel(parent)
{
}


/*bool LIFXLightsModel::insertRow(int row, const QModelIndex & parent = QModelIndex())
{
    beginInsertRows( QModelIndex(), 0, 0 ); //notify views and proxy models that a line will be inserted

    m_data.prepend( somedata ); // do the modification to the model data
    endInsertRows(); //finish insertion, notify views/models
}*/

/*bool LIFXLightsModel::setData(const QModelIndex & index, const QVariant & value, int role /*= Qt::EditRole* /)
{
    // Check that the index is valid and within the correct range first:
    if (!index.isValid())
        return false;
    if (index.row() >= m_lightsList.size())
        return false;

    if (role == Qt::EditRole)
    {
    // Only returns something for the roles you support (DisplayRole is a minimum)
    // Here we assume that the "Employee" class has a "lastName" method but of course any string can be returned
        m_lightsList.insert( index.row(), (QTIoT::LIFX::LIFXLightClient) &value);
        return true;
    }

    return false;
}*/

bool LIFXLightsModel::appendLight( QTIoT::LIFX::LIFXLightClient* light, int index)
{
    if(index > m_lightsList.size())
        return false;

    beginInsertRows( QModelIndex(), 0, 0 ); //notify views and proxy models that a line will be inserted
    if(index < 0)
        m_lightsList.append(light);
    else
        m_lightsList.insert(index, light);

    endInsertRows(); //finish insertion, notify views/models
    //emit countChanged();

    return true;
}
QTIoT::LIFX::LIFXLightClient* LIFXLightsModel::getLight( int index )
{
    std::cout << "index: " << index << " - count: " << m_lightsList.count() << std::endl;

    if (index < 0 || index >= m_lightsList.size())
        return NULL;// QVariant();

	QTIoT::LIFX::LIFXLightClient *light = m_lightsList.at(index);
	QByteArray txt_utf8 = light->getLabel().toUtf8();

	//std::cout << "returning: " << m_lightsList.at(index)->getLabel().toUtf8().constData() << std::endl;
	std::cout << "returning: " << txt_utf8.constData() << "@" << static_cast<void*>(light) << std::endl;

	return light;
	//return m_lightsList.at(index) ;
}
QVariant LIFXLightsModel::data(const QModelIndex& index, int role) const
{

    // Check that the index is valid and within the correct range first:
    if (!index.isValid())
        return QVariant();
    if (index.row() < 0 || index.row() >= m_lightsList.size())
        return QVariant();

    //if (role == Qt::ObjectRole Qt::ObjectRole)
    //    return QVariant::fromValue(m_lightsList.at(index.row()));

    if (role == Qt::DisplayRole)
    {
    // Only returns something for the roles you support (DisplayRole is a minimum)
    // Here we assume that the "Employee" class has a "lastName" method but of course any string can be returned
    //    return QVariant( m_lightsList.at(index.row())->getLabel());  //  employees_.at(index.row())->lastName());
    }

     QTIoT::LIFX::LIFXLightClient* light = m_lightsList[index.row()];
    switch(role)
    {
        case (LabelRole): return light->getLabel();
        case (ColorRole): return light->getColour();
        case (TemperatureRole): return light->getTemperature();
        case (BrightnessRole): return light->getBrightness();
        case (PowerRole): return light->getPower();
		case (TimeRole): return light->getTimeQDateTime();
		case (SelectedRole):return m_lightsSelected[index.row()];
	}

    return QVariant();

}
bool LIFXLightsModel::setData(const QModelIndex & index, const QVariant & value, int role /*= Qt::EditRole*/)
{

	// Check that the index is valid and within the correct range first:
	if (!index.isValid())
		return false;
	if (index.row() < 0 || index.row() >= m_lightsList.size())
		return false;

	//if (role == Qt::ObjectRole Qt::ObjectRole)
	//    return QVariant::fromValue(m_lightsList.at(index.row()));

	if (role == Qt::DisplayRole)
	{
	// Only returns something for the roles you support (DisplayRole is a minimum)
	// Here we assume that the "Employee" class has a "lastName" method but of course any string can be returned
	//    return QVariant( m_lightsList.at(index.row())->getLabel());  //  employees_.at(index.row())->lastName());
	}

	QTIoT::LIFX::LIFXLightClient* light = m_lightsList[index.row()];
	switch(role)
	{
		case (LabelRole): light->setLabel(value.toString()); return true;
		case (ColorRole): light->setColour(value.value<QColor>()); return true;
		case (TemperatureRole): light->setTemperature(value.toInt()); return true;
		case (BrightnessRole): light->setBrightness(value.toFloat()); return true;
		case (SaturationRole): light->setSaturation(value.toFloat()); return true;
		case (PowerRole): light->setPower(value.toBool()); return true;
		case (TimeRole): light->setTime(value.toDateTime()); return true;
		case (SelectedRole): m_lightsSelected[index.row()] = value.toBool(); return true;
	}

	return false;
}

/*enum LIFXLightsRoles {
    LabelRole = Qt::UserRole + 1,
    ColorRole,
    TemperatureRole,
    BrightnessRole,
    PowerRole,
    TimeRole
};*/

QHash<int, QByteArray> LIFXLightsModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[LabelRole]    = "label";
    roles[ColorRole]    = "color";
    roles[TemperatureRole]  = "temperature";
	roles[BrightnessRole]   = "brightness";
	roles[SaturationRole]   = "saturation";
	roles[PowerRole]    = "power";
    roles[TimeRole]     = "time";
	//For the UI/UX
	roles[SelectedRole] = "selected";
    return roles;
}
Qt::ItemFlags LIFXLightsModel::flags(const QModelIndex & /*index*/) const
{
	return Qt::ItemIsEnabled;
	return Qt::ItemIsSelectable |  Qt::ItemIsEditable | Qt::ItemIsEnabled;
}
int LIFXLightsModel::countSelectedLights()
{
	int count = 0;
	for(int n = 0; n < m_lightsSelected.count(); n++)
	{
			if(m_lightsSelected[n] == true)
				count++;
	}
	return count;
}
bool LIFXLightsModel::isSelectedLight(int index)
{
	if(m_lightsSelected.contains(index))
		return m_lightsSelected[index];

	return false;
}
