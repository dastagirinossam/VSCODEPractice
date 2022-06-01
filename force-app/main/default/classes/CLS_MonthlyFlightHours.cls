public class CLS_MonthlyFlightHours
{
	/*public static string fn_getStringIds(list<id> IdsToConcatenate_List)
	 {
		string strReturnedIds = '(';
		for(id idItem : IdsToConcatenate_List)
		{
			if(strReturnedIds.length() > 1)
			{
				strReturnedIds += ',';
			} 
			strReturnedIds += '\'' + idItem + '\'';
		}
		strReturnedIds += ')';
		return strReturnedIds;
	 }*/
	 
	 public static double fn_calAverageFlightHours(Date newDate, Date oldDate, Double newHour, Double oldHour)
	 {
	 	Double returnAverageHours = 0.0;
		Double DaysDifference = oldDate.daysBetween(newDate);
		Double HourDiffrence = newHour - oldHour;
		returnAverageHours = ((HourDiffrence/DaysDifference)* 365)/12;
		returnAverageHours = math.ceil(returnAverageHours);
		return returnAverageHours;
	 }
	 
	 public static list<Equipment__c> fn_getListForUpdateEQ(list<Equipment__c> equipments)
	 {
	 	map<Id, Double> EquipmentsMap = new map<Id, Double>();
	 	list<Equipment__c> EngineUpdate = new list<Equipment__c>();
	 	for(Integer i=0;i<equipments.size(); i++)
		{
			if(EquipmentsMap.containsKey(equipments.get(i).Id))
			{
				EquipmentsMap.put(equipments.get(i).Id, equipments.get(i).Average_Monthly_Hours__c);
			}
			else
			{
				EquipmentsMap.put(equipments.get(i).Id, equipments.get(i).Average_Monthly_Hours__c);
			}
		}
		set<Id> s = new set<Id>();
		s = EquipmentsMap.keySet();
		for(Id st : s)
		{
			Equipment__c ac = new Equipment__c(Id =st, Average_Monthly_Hours__c = EquipmentsMap.get(st));
			EngineUpdate.add(ac);
		}
		return EngineUpdate;
	 }
	 
	 public static list<Aircraft__c> fn_getListForUpdateAC(list<Aircraft__c> Aircrafts)
	 {
	 	map<Id, Double> AircraftsMap = new map<Id, Double>();
	 	list<Aircraft__c> AircraftsUpdate = new list<Aircraft__c>();
	 	for(Integer i=0;i<Aircrafts.size(); i++)
		{
			if(AircraftsMap.containsKey(Aircrafts.get(i).Id))
			{
				AircraftsMap.put(Aircrafts.get(i).Id, Aircrafts.get(i).Average_Monthly_Hours__c);
			}
			else
			{
				AircraftsMap.put(Aircrafts.get(i).Id, Aircrafts.get(i).Average_Monthly_Hours__c);
			}
		}
		set<Id> s = new set<Id>();
		s = AircraftsMap.keySet();
		for(Id st : s)
		{
			System.debug(st);
			Aircraft__c ac = new Aircraft__c(Id = st, Average_Monthly_Hours__c = AircraftsMap.get(st));
			AircraftsUpdate.add(ac);
		}
		return AircraftsUpdate;
	 }
}