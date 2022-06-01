global class fsl_UpdateStatus_Tentative implements FSL.CustomGanttServiceAppointmentAction {
 
    global String action(List<Id> serviceAppointmentsIds, Datetime ganttStartDate, Datetime ganttEndDate, Map<String, Object> additionalParameters) {
       
        List<ServiceAppointment> saList = [SELECT Status FROM ServiceAppointment WHERE Id in : serviceAppointmentsIds];
        List<ServiceAppointment> saUpdateList = new List<ServiceAppointment>();
 
        for (ServiceAppointment s : saList) {
            s.Status = 'Tentative';
            saUpdateList.add(s);
        }
       
        update saUpdateList;
        
        return 'Service Appointment Status Updated - Tentative';
    }
   
}