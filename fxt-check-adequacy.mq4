_snprintf(tmp,sizeof(tmp)-1,"%s\\tester\\history\\%s%d_%d.fxt",ExtProgramPath,scheme->symbol,scheme->period,model);
if((m_file=fopen(tmp,"rb"))!=NULL)
{
  //---- header adequacy check
  if(fread(&m_header,sizeof(m_header),1,m_file)==1 &&
      m_header.version==TestHistoryVersion   &&
      m_header.model==model && m_header.period==scheme->period &&
      strcmp(m_header.symbol,scheme->symbol)==0)
  {
    //---- next check
    if(m_header.bars<=100   || m_header.modelquality<0.0 ||
        m_header.spread<0    || m_header.spread>100000 ||
        m_header.digits<0    || m_header.digits>8 ||
        m_header.lot_min<0   || m_header.lot_step<=0 ||
        m_header.leverage<=0 || m_header.leverage>500 ||
        m_header.swap_rollover3days<0 ||
        m_header.swap_rollover3days>6 ||
        m_header.stops_level<0) refresh=TRUE;
    //---- if recalculation is not needed then set m_testes_total and exit
    if(refresh==FALSE)
    {
      m_testes_total=(_filelength(_fileno(m_file))-sizeof(m_header))/sizeof(TestHistory);
      return(TRUE);
    }
  }
  //----
  fclose(m_file);
  m_file=NULL;
}
