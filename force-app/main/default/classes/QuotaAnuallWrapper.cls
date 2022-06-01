public class QuotaAnuallWrapper {
    
  
  @AuraEnabled  public String Name {get; set;}
  @AuraEnabled  public String salesEMPName {get; set;}
  @AuraEnabled  public String salesId {get; set;}
  @AuraEnabled  public  string Year {get; set;}
  @AuraEnabled  public String Region{get; set;}
  @AuraEnabled  public String Annual {get; set;}
   
  @AuraEnabled  public Decimal ActualRevenueEngines {get; set;}
  @AuraEnabled   public Decimal QuotaRevenueEngines {get; set;}
  @AuraEnabled   public Decimal PerformanceRevenueEngines {get; set;}
    
  @AuraEnabled  public Decimal ActualMarginEngines {get; set;}
  @AuraEnabled  public Decimal QuotaMarginEngines {get; set;}
  @AuraEnabled  public Decimal PerformanceMarginEngines {get; set;}
    
  @AuraEnabled  public Decimal ActualRevenueNonEngine {get; set;}
  @AuraEnabled  public Decimal QuotaRevenueNonEngine {get; set;}
  @AuraEnabled  public Decimal PerformanceRevenueNonEngine {get; set;}
    
  @AuraEnabled  public Decimal ActualMarginNonEngine {get; set;}
  @AuraEnabled  public Decimal QuotaMarginNonEngine {get; set;}
  @AuraEnabled  public Decimal PerformanceMarginNonEngine {get; set;}
    
    
  @AuraEnabled  public Decimal ActualRevenueTPEAll {get; set;}
  @AuraEnabled  public Decimal QuotaRevenueTPEAll {get; set;}
  @AuraEnabled  public Decimal PerformanceRevenueTPEAll {get; set;}
    
  @AuraEnabled  public Decimal ActualMarginTPEAll {get; set;}
  @AuraEnabled  public Decimal QuotaMarginTPEAll {get; set;}
  @AuraEnabled  public Decimal PerformanceMarginTPEALL {get; set;}
    
//  @AuraEnabled  public Decimal ActualMarginTPE731 {get; set;}
  //@AuraEnabled  public Decimal QuotaMarginTPE731 {get; set;}
 // @AuraEnabled  public Decimal PerformanceMarginTPE731 {get; set;}  
    
  @AuraEnabled  public Decimal ActualRevenueTotal {get; set;}
  @AuraEnabled   public Decimal QuotaRevenueTotal {get; set;}
  @AuraEnabled   public Decimal PerformanceRevenueTotal {get; set;}
    
  @AuraEnabled  public Decimal ActualMarginTotal {get; set;}
  @AuraEnabled  public Decimal QuotaMarginTotal {get; set;}
  @AuraEnabled  public Decimal PerformanceMarginTotal {get; set;}
    
  @AuraEnabled  public Decimal ActualRevenueTFE731 {get; set;}
  @AuraEnabled  public Decimal QuotaRevenueTFE731 {get; set;}
  @AuraEnabled  public Decimal PerformanceRevenueTFE731 {get; set;}
    
  @AuraEnabled  public Decimal ActualMarginTFE731 {get; set;}
  @AuraEnabled  public Decimal QuotaMarginTFE731 {get; set;}
  @AuraEnabled  public Decimal PerformanceMarginTFE731 {get; set;}
    
 
  @AuraEnabled  public Decimal ActualRevenueAirframe{get; set;}
  @AuraEnabled  public Decimal QuotaRevenueAirframe {get; set;}
  @AuraEnabled  public Decimal PerformanceRevenueAirframe {get; set;}
    
  @AuraEnabled  public Decimal ActualMarginAirframe {get; set;}
  @AuraEnabled  public Decimal QuotaMarginAirframe {get; set;}
  @AuraEnabled  public Decimal PerformanceMarginAirframe {get; set;}
    
  @AuraEnabled  public Decimal ActualRevenueHTF {get; set;}
  @AuraEnabled  public Decimal QuotaRevenueHTF {get; set;}
  @AuraEnabled  public Decimal PerformanceRevenueHTF {get; set;}
    
  @AuraEnabled  public Decimal ActualMarginHTF {get; set;}
  @AuraEnabled  public Decimal QuotaMarginHTF {get; set;}
  @AuraEnabled  public Decimal PerformanceMarginHTF {get; set;}
    
  @AuraEnabled  public Decimal ActualRevenueCFE738 {get; set;}
  @AuraEnabled  public Decimal QuotaRevenueCFE738 {get; set;}
  @AuraEnabled  public Decimal PerformanceRevenueCFE738 {get; set;}
    
  @AuraEnabled  public Decimal ActualMarginCFE738 {get; set;}
  @AuraEnabled  public Decimal QuotaMarginCFE738 {get; set;}
  @AuraEnabled  public Decimal PerformanceMarginCFE738 {get; set;}
    
 
    
  @AuraEnabled  public Decimal ActualRevenuePW300 {get; set;}
  @AuraEnabled  public Decimal QuotaRevenuePW300 {get; set;}
  @AuraEnabled  public Decimal PerformanceRevenuePW300 {get; set;}
    
  @AuraEnabled  public Decimal ActualMarginPW300 {get; set;}
  @AuraEnabled  public Decimal QuotaMarginPW300 {get; set;}
  @AuraEnabled  public Decimal PerformanceMarginPW300 {get; set;}
    
  @AuraEnabled  public Decimal ActualRevenuePW300Offload {get; set;}
  @AuraEnabled  public Decimal QuotaRevenuePW300Offload {get; set;}
  @AuraEnabled  public Decimal PerformanceRevenuePW300Offload {get; set;}
    
  @AuraEnabled  public Decimal ActualMarginPW300Offload {get; set;}
  @AuraEnabled  public Decimal QuotaMarginPW300Offload {get; set;}
  @AuraEnabled  public Decimal PerformanceMarginPW300Offload {get; set;}
    
  @AuraEnabled  public Decimal ActualRevenueOtherEngine {get; set;}
  @AuraEnabled  public Decimal QuotaRevenueOtherEngine {get; set;}
  @AuraEnabled  public Decimal PerformanceRevenueOtherEngine {get; set;}
    
  @AuraEnabled  public Decimal ActualMarginOtherEngine {get; set;}
  @AuraEnabled  public Decimal QuotaMarginOtherEngine {get; set;}
  @AuraEnabled  public Decimal PerformanceMarginOtherEngine {get; set;}
    
  @AuraEnabled  public Decimal ActualRevenueAPU {get; set;}
  @AuraEnabled  public Decimal QuotaRevenueAPU {get; set;}
  @AuraEnabled  public Decimal PerformanceRevenueAPU {get; set;}
    
  @AuraEnabled  public Decimal ActualRevenueAE3007 {get; set;}
  @AuraEnabled  public Decimal QuotaRevenueAE3007{get; set;}
  @AuraEnabled  public Decimal PerformanceRevenueAE3007 {get; set;}  
  
  @AuraEnabled  public Decimal ActualRevenueEngineExchange {get; set;}
  @AuraEnabled  public Decimal QuotaRevenueEngineExchange{get; set;}
  @AuraEnabled  public Decimal PerformanceRevenueEngineExchange {get; set;}   
  
   @AuraEnabled  public Decimal ActualMarginAPU {get; set;}
  @AuraEnabled  public Decimal QuotaMarginAPU {get; set;}
  @AuraEnabled  public Decimal PerformanceMarginAPU {get; set;}
    
  @AuraEnabled  public Decimal ActualMarginAE3007 {get; set;}
  @AuraEnabled  public Decimal QuotaMarginAE3007{get; set;}
  @AuraEnabled  public Decimal PerformanceMarginAE3007 {get; set;}  
  
  @AuraEnabled  public Decimal ActualMarginEngineExchange {get; set;}
  @AuraEnabled  public Decimal QuotaMarginEngineExchange{get; set;}
  @AuraEnabled  public Decimal PerformanceMarginEngineExchange {get; set;}
  
  @AuraEnabled  public Decimal ActualRevenueAvionics {get; set;}
  @AuraEnabled  public Decimal QuotaRevenueAvionics {get; set;}
  @AuraEnabled  public Decimal PerformanceRevenueAvionics {get; set;}      
      
  @AuraEnabled  public Decimal ActualMarginAvionics {get; set;}
  @AuraEnabled  public Decimal QuotaMarginAvionics {get; set;}
  @AuraEnabled  public Decimal PerformanceMarginAvionics {get; set;}  
    
  @AuraEnabled  public Decimal ActualRevenueEngineSplits {get; set;}
  @AuraEnabled  public Decimal ActualRevenueNonEngineSplits {get; set;}
  @AuraEnabled  public Decimal ActualRevenueOther {get; set;}
  @AuraEnabled  public Decimal ActualRevenueInteriorMods {get; set;}
  @AuraEnabled  public Decimal QuotaRevenueInteriorMods {get; set;}
  @AuraEnabled  public Decimal PerformanceRevenueInteriorMods {get; set;}
    
  @AuraEnabled  public Decimal ActualMarginEnginesSplits {get; set;}
  @AuraEnabled  public Decimal ActualMarginNonEngineSplits {get; set;}
  @AuraEnabled  public Decimal ActualMarginOther {get; set;}
  @AuraEnabled  public Decimal ActualMarginInteriorMods {get; set;}
  @AuraEnabled  public Decimal QuotaMarginInteriorMods {get; set;}
  @AuraEnabled  public Decimal PerformanceMarginInteriorMods {get; set;}
    
  @AuraEnabled  public Decimal ActualRevenuePaint {get; set;}
  @AuraEnabled  public Decimal QuotaRevenuePaint {get; set;}
  @AuraEnabled  public Decimal PerformanceRevenuePaint {get; set;}      
      
  @AuraEnabled  public Decimal ActualMarginPaint {get; set;}
  @AuraEnabled  public Decimal QuotaMarginPaint {get; set;}
  @AuraEnabled  public Decimal PerformanceMarginPaint {get; set;}  
    
  @AuraEnabled  public Decimal ActualRevenueODA {get; set;}
  @AuraEnabled  public Decimal QuotaRevenueODA {get; set;}
  @AuraEnabled  public Decimal PerformanceRevenueODA {get; set;}
    
  @AuraEnabled  public Decimal ActualMarginODA {get; set;}
  @AuraEnabled  public Decimal QuotaMarginODA {get; set;}
  @AuraEnabled  public Decimal PerformanceMarginODA {get; set;}
    
  @AuraEnabled  public Decimal ActualRevenuePPE {get; set;}
  @AuraEnabled  public Decimal QuotaRevenuePPE {get; set;}
  @AuraEnabled  public Decimal PerformanceRevenuePPE {get; set;}
    
  @AuraEnabled  public Decimal ActualMarginPPE {get; set;}
  @AuraEnabled  public Decimal QuotaMarginPPE {get; set;}
  @AuraEnabled  public Decimal PerformanceMarginPPE {get; set;}
    
    
    
}