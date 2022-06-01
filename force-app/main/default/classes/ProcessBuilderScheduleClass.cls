global class ProcessBuilderScheduleClass implements Schedulable {
   global void execute(SchedulableContext SC) {
      Database.executeBatch(new ProcessBuilderApexCalss());
   }
}