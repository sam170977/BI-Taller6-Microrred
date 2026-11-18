# Inventario de Bronze

Archivo: `opencem-v1.0.0.sqlite`  
Generado: 2026-11-17 08:48

| Objeto | Tipo | Filas | Columnas |
|---|---|---:|---:|
| analog_measurements | table | 2,989,759 | 44 |
| context | table | 25,178 | 5 |
| fault_history | table | 2,129,517 | 66 |
| settings | table | 2,284,775 | 176 |
| specs | table | 1,333,174 | 16 |
| statistics | table | 2,285,904 | 31 |
| status | table | 2,240,052 | 20 |
| totals | table | 2,279,918 | 21 |

## analog_measurements

Filas: **2,989,759** · Columnas: **44**

Rango de columnas de tiempo:

- `read_ts`: de 1752327095.265811 (2025-07-12 13:31:35 UTC, época en s) a 1783919633.451776 (2026-07-13 05:13:53 UTC, época en s)

| Columna | Tipo | % nulos |
|---|---|---:|
| read_ts | REAL | 0.0 |
| inverter | INTEGER | 0.0 |
| battvolt | REAL | 1.9 |
| battcurr | REAL | 1.9 |
| battsoc | INTEGER | 1.9 |
| battchgpower | INTEGER | 1.9 |
| linechgcurr | REAL | 1.9 |
| pvchgcurr | REAL | 1.9 |
| battreserve | TEXT | 0.1 |
| pv1volt | REAL | 2.0 |
| pv1curr | REAL | 1.9 |
| pv1power | INTEGER | 2.0 |
| pvreserve | TEXT | 0.1 |
| outvolta | REAL | 2.0 |
| outcurra | REAL | 1.9 |
| outfreq | REAL | 2.0 |
| invcurra | REAL | 1.9 |
| outw_a | INTEGER | 2.0 |
| outva_a | INTEGER | 1.9 |
| loadpercenta | INTEGER | 1.9 |
| normalloadw_a | INTEGER | 1.9 |
| outsumw | INTEGER | 1.9 |
| outsumva | INTEGER | 1.9 |
| sumloadpercent | INTEGER | 1.9 |
| generatedpowerp_a | INTEGER | 1.9 |
| generatedpowers_a | INTEGER | 1.9 |
| generatedpowerq_a | INTEGER | 1.9 |
| linevolta | REAL | 1.9 |
| linecurra | REAL | 1.9 |
| linefreq | REAL | 1.9 |
| linepowerva_a | INTEGER | 1.9 |
| linepowerw_a | INTEGER | 1.9 |
| busvoltp | REAL | 1.9 |
| busvoltn | REAL | 1.9 |
| temper1 | REAL | 1.9 |
| temper2 | REAL | 2.0 |
| temper3 | REAL | 1.9 |
| temper4 | REAL | 1.9 |
| sir | INTEGER | 1.9 |
| fanduty | INTEGER | 1.9 |
| otherreserve | TEXT | 0.1 |
| gridpowerw_a | INTEGER | 2.0 |
| gridcurr_a | REAL | 2.0 |
| grid_reserve | TEXT | 0.2 |

Muestra (3 filas):

- read_ts=1753164464.056726, inverter=1, battvolt=54.2, battcurr=1.3, battsoc=95, battchgpower=0, linechgcurr=0.0, pvchgcurr=0.0, battreserve=[0,0,0,0,0], pv1volt=454.1, pv1curr=0.2, pv1power=90, pvreserve=[0,0,0,0], outvolta=230.0, outcurra=0.7, outfreq=50.0, invcurra=1.6, outw_a=103, outva_a=161, loadpercenta=2, normalloadw_a=0, outsumw=102, outsumva=161, sumloadpercent=2, generatedpowerp_a=0, generatedpowers_a=0, generatedpowerq_a=0, linevolta=236.8, linecurra=0.0, linefreq=49.99, linepowerva_a=0, linepowerw_a=0, busvoltp=461.2, busvoltn=0.0, temper1=35.5, temper2=40.5, temper3=51.4, temper4=120.0, sir=0, fanduty=0, otherreserve=[0,0,0,0,0], gridpowerw_a=59, gridcurr_a=1.5, grid_reserve=[0,0,0,0,0,0,0,0,0,0]
- read_ts=1752676875.785619, inverter=1, battvolt=52.5, battcurr=2.9, battsoc=88, battchgpower=0, linechgcurr=0.0, pvchgcurr=0.0, battreserve=[0,0,0,0,0], pv1volt=0.0, pv1curr=0.0, pv1power=0, pvreserve=[0,0,0,0], outvolta=None, outcurra=0.7, outfreq=None, invcurra=1.6, outw_a=None, outva_a=161, loadpercenta=None, normalloadw_a=0, outsumw=102, outsumva=161, sumloadpercent=2, generatedpowerp_a=0, generatedpowers_a=0, generatedpowerq_a=0, linevolta=234.0, linecurra=0.0, linefreq=49.96, linepowerva_a=0, linepowerw_a=0, busvoltp=399.6, busvoltn=0.0, temper1=34.6, temper2=41.5, temper3=54.4, temper4=120.0, sir=0, fanduty=0, otherreserve=[0,0,0,0,0], gridpowerw_a=58, gridcurr_a=1.5, grid_reserve=[0,0,0,0,0,0,0,0,0,0]
- read_ts=1752677277.276577, inverter=1, battvolt=52.7, battcurr=3.0, battsoc=None, battchgpower=0, linechgcurr=None, pvchgcurr=0.0, battreserve=[0,0,0,0,0], pv1volt=0.0, pv1curr=0.0, pv1power=0, pvreserve=[0,0,0,0], outvolta=None, outcurra=0.7, outfreq=50.0, invcurra=1.6, outw_a=105, outva_a=161, loadpercenta=2, normalloadw_a=None, outsumw=103, outsumva=161, sumloadpercent=2, generatedpowerp_a=None, generatedpowers_a=0, generatedpowerq_a=0, linevolta=233.7, linecurra=0.0, linefreq=50.0, linepowerva_a=0, linepowerw_a=0, busvoltp=399.5, busvoltn=0.0, temper1=36.7, temper2=43.1, temper3=57.1, temper4=120.0, sir=0, fanduty=0, otherreserve=[0,0,0,0,0], gridpowerw_a=None, gridcurr_a=1.5, grid_reserve=[0,0,0,0,0,0,0,0,0,0]

## context

Filas: **25,178** · Columnas: **5**

Rango de columnas de tiempo:

- `start`: de 1714492800 (2024-04-30 16:00:00 UTC, época en s) a 1784476800 (2026-07-19 16:00:00 UTC, época en s)
- `end`: de 1714924800 (2024-05-05 16:00:00 UTC, época en s) a 1784735999 (2026-07-22 15:59:59 UTC, época en s)

| Columna | Tipo | % nulos |
|---|---|---:|
| id | INTEGER | 0.0 |
| recorded | INTEGER | 0.0 |
| start | INTEGER | 0.0 |
| end | INTEGER | 0.0 |
| value | TEXT | 0.0 |

Muestra (3 filas):

- id=1, recorded=1748956810, start=1714492800, end=1714924800, value={"source": "manual entry", "textual_description": "Public Ho
- id=2, recorded=1748956810, start=1715270400, end=1715356800, value={"source": "manual entry", "textual_description": "Last day 
- id=3, recorded=1748956810, start=1715356800, end=1716048000, value={"source": "manual entry", "textual_description": "Course Ex

## fault_history

Filas: **2,129,517** · Columnas: **66**

Rango de columnas de tiempo:

- `read_ts`: de 1752327095.265811 (2025-07-12 13:31:35 UTC, época en s) a 1783919633.451776 (2026-07-13 05:13:53 UTC, época en s)
- `faulthistoryrecord00_time`: de 1751083387.480223 (2025-06-28 04:03:07 UTC, época en s) a 1783913279.785157 (2026-07-13 03:27:59 UTC, época en s)
- `faulthistoryrecord01_time`: de 1751084491.480223 (2025-06-28 04:21:31 UTC, época en s) a 1783913300.785157 (2026-07-13 03:28:20 UTC, época en s)
- `faulthistoryrecord02_time`: de 1751084491.480223 (2025-06-28 04:21:31 UTC, época en s) a 1783913322.785157 (2026-07-13 03:28:42 UTC, época en s)
- `faulthistoryrecord03_time`: de 1751084491.480223 (2025-06-28 04:21:31 UTC, época en s) a 1761260728.868479 (2025-10-23 23:05:28 UTC, época en s)
- `faulthistoryrecord04_time`: de 1751084557.480223 (2025-06-28 04:22:37 UTC, época en s) a 1761260748.868478 (2025-10-23 23:05:48 UTC, época en s)
- `faulthistoryrecord05_time`: de 1751332377.480223 (2025-07-01 01:12:57 UTC, época en s) a 1761260770.868478 (2025-10-23 23:06:10 UTC, época en s)
- `faulthistoryrecord06_time`: de 1751338641.480223 (2025-07-01 02:57:21 UTC, época en s) a 1761260792.868478 (2025-10-23 23:06:32 UTC, época en s)
- `faulthistoryrecord07_time`: de 1751338790.480223 (2025-07-01 02:59:50 UTC, época en s) a 1761260813.868478 (2025-10-23 23:06:53 UTC, época en s)
- `faulthistoryrecord08_time`: de 1751342863.480223 (2025-07-01 04:07:43 UTC, época en s) a 1761260826.868478 (2025-10-23 23:07:06 UTC, época en s)
- `faulthistoryrecord09_time`: de 1751674756.480223 (2025-07-05 00:19:16 UTC, época en s) a 1761261557.679113 (2025-10-23 23:19:17 UTC, época en s)
- `faulthistoryrecord10_time`: de 1751677192.480223 (2025-07-05 00:59:52 UTC, época en s) a 1761261577.679113 (2025-10-23 23:19:37 UTC, época en s)
- `faulthistoryrecord11_time`: de 1751677195.480223 (2025-07-05 00:59:55 UTC, época en s) a 1761261597.679113 (2025-10-23 23:19:57 UTC, época en s)
- `faulthistoryrecord12_time`: de 1752029221.480223 (2025-07-09 02:47:01 UTC, época en s) a 1761261615.679113 (2025-10-23 23:20:15 UTC, época en s)
- `faulthistoryrecord13_time`: de 1752033650.480223 (2025-07-09 04:00:50 UTC, época en s) a 1761261633.679113 (2025-10-23 23:20:33 UTC, época en s)
- `faulthistoryrecord14_time`: de 1752302130.480223 (2025-07-12 06:35:30 UTC, época en s) a 1761261649.176876 (2025-10-23 23:20:49 UTC, época en s)
- `faulthistoryrecord15_time`: de 1752302152.480223 (2025-07-12 06:35:52 UTC, época en s) a 1761261662.176876 (2025-10-23 23:21:02 UTC, época en s)
- `faulthistoryrecord16_time`: de 1752302221.480223 (2025-07-12 06:37:01 UTC, época en s) a 1761254181.434292 (2025-10-23 21:16:21 UTC, época en s)
- `faulthistoryrecord17_time`: de 1752302223.480223 (2025-07-12 06:37:03 UTC, época en s) a 1761254194.434292 (2025-10-23 21:16:34 UTC, época en s)
- `faulthistoryrecord18_time`: de 1752302609.480223 (2025-07-12 06:43:29 UTC, época en s) a 1761256301.893208 (2025-10-23 21:51:41 UTC, época en s)
- `faulthistoryrecord19_time`: de 1752302921.480223 (2025-07-12 06:48:41 UTC, época en s) a 1761256323.644785 (2025-10-23 21:52:03 UTC, época en s)
- `faulthistoryrecord20_time`: de 1752303732.480223 (2025-07-12 07:02:12 UTC, época en s) a 1761256343.644785 (2025-10-23 21:52:23 UTC, época en s)
- `faulthistoryrecord21_time`: de 1752304007.480223 (2025-07-12 07:06:47 UTC, época en s) a 1761256361.644785 (2025-10-23 21:52:41 UTC, época en s)
- `faulthistoryrecord22_time`: de 1752304133.480223 (2025-07-12 07:08:53 UTC, época en s) a 1761256379.644785 (2025-10-23 21:52:59 UTC, época en s)
- `faulthistoryrecord23_time`: de 1752305019.480223 (2025-07-12 07:23:39 UTC, época en s) a 1761256397.644785 (2025-10-23 21:53:17 UTC, época en s)
- `faulthistoryrecord24_time`: de 1752306059.480223 (2025-07-12 07:40:59 UTC, época en s) a 1761260477.417555 (2025-10-23 23:01:17 UTC, época en s)
- `faulthistoryrecord25_time`: de 1752308246.480223 (2025-07-12 08:17:26 UTC, época en s) a 1761260506.417555 (2025-10-23 23:01:46 UTC, época en s)
- `faulthistoryrecord26_time`: de 1751082968.480223 (2025-06-28 03:56:08 UTC, época en s) a 1761260532.868478 (2025-10-23 23:02:12 UTC, época en s)
- `faulthistoryrecord27_time`: de 1751083000.480223 (2025-06-28 03:56:40 UTC, época en s) a 1761260555.868478 (2025-10-23 23:02:35 UTC, época en s)
- `faulthistoryrecord28_time`: de 1751083000.480223 (2025-06-28 03:56:40 UTC, época en s) a 1761260579.868478 (2025-10-23 23:02:59 UTC, época en s)
- `faulthistoryrecord29_time`: de 1751083141.480223 (2025-06-28 03:59:01 UTC, época en s) a 1761260600.868478 (2025-10-23 23:03:20 UTC, época en s)
- `faulthistoryrecord30_time`: de 1751083141.480223 (2025-06-28 03:59:01 UTC, época en s) a 1761260622.868478 (2025-10-23 23:03:42 UTC, época en s)
- `faulthistoryrecord31_time`: de 1751083142.480223 (2025-06-28 03:59:02 UTC, época en s) a 1761260644.868479 (2025-10-23 23:04:04 UTC, época en s)

| Columna | Tipo | % nulos |
|---|---|---:|
| read_ts | REAL | 0.0 |
| inverter | INTEGER | 0.0 |
| faulthistoryrecord00 | TEXT | 0.3 |
| faulthistoryrecord01 | TEXT | 0.2 |
| faulthistoryrecord02 | TEXT | 0.3 |
| faulthistoryrecord03 | TEXT | 95.6 |
| faulthistoryrecord04 | TEXT | 95.6 |
| faulthistoryrecord05 | TEXT | 95.6 |
| faulthistoryrecord06 | TEXT | 95.6 |
| faulthistoryrecord07 | TEXT | 95.6 |
| faulthistoryrecord08 | TEXT | 95.6 |
| faulthistoryrecord09 | TEXT | 95.6 |
| faulthistoryrecord10 | TEXT | 95.6 |
| faulthistoryrecord11 | TEXT | 95.6 |
| faulthistoryrecord12 | TEXT | 95.6 |
| faulthistoryrecord13 | TEXT | 95.6 |
| faulthistoryrecord14 | TEXT | 95.6 |
| faulthistoryrecord15 | TEXT | 95.6 |
| faulthistoryrecord16 | TEXT | 95.6 |
| faulthistoryrecord17 | TEXT | 95.6 |
| faulthistoryrecord18 | TEXT | 95.6 |
| faulthistoryrecord19 | TEXT | 95.6 |
| faulthistoryrecord20 | TEXT | 95.6 |
| faulthistoryrecord21 | TEXT | 95.6 |
| faulthistoryrecord22 | TEXT | 95.6 |
| faulthistoryrecord23 | TEXT | 95.6 |
| faulthistoryrecord24 | TEXT | 95.6 |
| faulthistoryrecord25 | TEXT | 95.6 |
| faulthistoryrecord26 | TEXT | 95.6 |
| faulthistoryrecord27 | TEXT | 95.6 |
| faulthistoryrecord28 | TEXT | 95.6 |
| faulthistoryrecord29 | TEXT | 95.6 |
| faulthistoryrecord30 | TEXT | 95.6 |
| faulthistoryrecord31 | TEXT | 95.6 |
| faulthistoryrecord00_time | REAL | 4.0 |
| faulthistoryrecord01_time | REAL | 3.9 |
| faulthistoryrecord02_time | REAL | 3.9 |
| faulthistoryrecord03_time | REAL | 96.6 |
| faulthistoryrecord04_time | REAL | 96.6 |
| faulthistoryrecord05_time | REAL | 96.6 |
| faulthistoryrecord06_time | REAL | 96.6 |
| faulthistoryrecord07_time | REAL | 96.6 |
| faulthistoryrecord08_time | REAL | 96.6 |
| faulthistoryrecord09_time | REAL | 96.6 |
| faulthistoryrecord10_time | REAL | 96.6 |
| faulthistoryrecord11_time | REAL | 96.6 |
| faulthistoryrecord12_time | REAL | 96.6 |
| faulthistoryrecord13_time | REAL | 96.6 |
| faulthistoryrecord14_time | REAL | 96.6 |
| faulthistoryrecord15_time | REAL | 96.7 |
| faulthistoryrecord16_time | REAL | 96.6 |
| faulthistoryrecord17_time | REAL | 96.6 |
| faulthistoryrecord18_time | REAL | 96.6 |
| faulthistoryrecord19_time | REAL | 96.6 |
| faulthistoryrecord20_time | REAL | 96.6 |
| faulthistoryrecord21_time | REAL | 96.6 |
| faulthistoryrecord22_time | REAL | 96.6 |
| faulthistoryrecord23_time | REAL | 96.6 |
| faulthistoryrecord24_time | REAL | 96.6 |
| faulthistoryrecord25_time | REAL | 96.6 |
| faulthistoryrecord26_time | REAL | 96.6 |
| faulthistoryrecord27_time | REAL | 96.6 |
| faulthistoryrecord28_time | REAL | 96.8 |
| faulthistoryrecord29_time | REAL | 96.7 |
| faulthistoryrecord30_time | REAL | 96.6 |
| faulthistoryrecord31_time | REAL | 96.6 |

Muestra (3 filas):

- read_ts=1752465748.413826, inverter=1, faulthistoryrecord00=None, faulthistoryrecord01=None, faulthistoryrecord02=None, faulthistoryrecord03=None, faulthistoryrecord04=None, faulthistoryrecord05=None, faulthistoryrecord06=None, faulthistoryrecord07=None, faulthistoryrecord08=None, faulthistoryrecord09=None, faulthistoryrecord10=None, faulthistoryrecord11=None, faulthistoryrecord12=None, faulthistoryrecord13=None, faulthistoryrecord14=None, faulthistoryrecord15=None, faulthistoryrecord16=None, faulthistoryrecord17=None, faulthistoryrecord18=None, faulthistoryrecord19=None, faulthistoryrecord20=None, faulthistoryrecord21=None, faulthistoryrecord22=None, faulthistoryrecord23=None, faulthistoryrecord24=None, faulthistoryrecord25=None, faulthistoryrecord26=None, faulthistoryrecord27=None, faulthistoryrecord28=None, faulthistoryrecord29=None, faulthistoryrecord30=None, faulthistoryrecord31=None, faulthistoryrecord00_time=None, faulthistoryrecord01_time=None, faulthistoryrecord02_time=None, faulthistoryrecord03_time=None, faulthistoryrecord04_time=None, faulthistoryrecord05_time=None, faulthistoryrecord06_time=None, faulthistoryrecord07_time=None, faulthistoryrecord08_time=None, faulthistoryrecord09_time=None, faulthistoryrecord10_time=None, faulthistoryrecord11_time=None, faulthistoryrecord12_time=None, faulthistoryrecord13_time=None, faulthistoryrecord14_time=None, faulthistoryrecord15_time=None, faulthistoryrecord16_time=None, faulthistoryrecord17_time=None, faulthistoryrecord18_time=None, faulthistoryrecord19_time=None, faulthistoryrecord20_time=None, faulthistoryrecord21_time=None, faulthistoryrecord22_time=None, faulthistoryrecord23_time=None, faulthistoryrecord24_time=None, faulthistoryrecord25_time=None, faulthistoryrecord26_time=None, faulthistoryrecord27_time=None, faulthistoryrecord28_time=None, faulthistoryrecord29_time=None, faulthistoryrecord30_time=None, faulthistoryrecord31_time=None
- read_ts=1752466092.254249, inverter=1, faulthistoryrecord00=None, faulthistoryrecord01=None, faulthistoryrecord02=None, faulthistoryrecord03=None, faulthistoryrecord04=None, faulthistoryrecord05=None, faulthistoryrecord06=None, faulthistoryrecord07=None, faulthistoryrecord08=None, faulthistoryrecord09=None, faulthistoryrecord10=None, faulthistoryrecord11=None, faulthistoryrecord12=None, faulthistoryrecord13=None, faulthistoryrecord14=None, faulthistoryrecord15=None, faulthistoryrecord16=None, faulthistoryrecord17=None, faulthistoryrecord18=None, faulthistoryrecord19=None, faulthistoryrecord20=None, faulthistoryrecord21=None, faulthistoryrecord22=None, faulthistoryrecord23=None, faulthistoryrecord24=None, faulthistoryrecord25=None, faulthistoryrecord26=None, faulthistoryrecord27=None, faulthistoryrecord28=None, faulthistoryrecord29=None, faulthistoryrecord30=None, faulthistoryrecord31=None, faulthistoryrecord00_time=None, faulthistoryrecord01_time=None, faulthistoryrecord02_time=None, faulthistoryrecord03_time=None, faulthistoryrecord04_time=None, faulthistoryrecord05_time=None, faulthistoryrecord06_time=None, faulthistoryrecord07_time=None, faulthistoryrecord08_time=None, faulthistoryrecord09_time=None, faulthistoryrecord10_time=None, faulthistoryrecord11_time=None, faulthistoryrecord12_time=None, faulthistoryrecord13_time=None, faulthistoryrecord14_time=None, faulthistoryrecord15_time=None, faulthistoryrecord16_time=None, faulthistoryrecord17_time=None, faulthistoryrecord18_time=None, faulthistoryrecord19_time=None, faulthistoryrecord20_time=None, faulthistoryrecord21_time=None, faulthistoryrecord22_time=None, faulthistoryrecord23_time=None, faulthistoryrecord24_time=None, faulthistoryrecord25_time=None, faulthistoryrecord26_time=None, faulthistoryrecord27_time=None, faulthistoryrecord28_time=None, faulthistoryrecord29_time=None, faulthistoryrecord30_time=None, faulthistoryrecord31_time=None
- read_ts=1752466428.230209, inverter=1, faulthistoryrecord00=None, faulthistoryrecord01=None, faulthistoryrecord02=None, faulthistoryrecord03=None, faulthistoryrecord04=None, faulthistoryrecord05=None, faulthistoryrecord06=None, faulthistoryrecord07=None, faulthistoryrecord08=None, faulthistoryrecord09=None, faulthistoryrecord10=None, faulthistoryrecord11=None, faulthistoryrecord12=None, faulthistoryrecord13=None, faulthistoryrecord14=None, faulthistoryrecord15=None, faulthistoryrecord16=None, faulthistoryrecord17=None, faulthistoryrecord18=None, faulthistoryrecord19=None, faulthistoryrecord20=None, faulthistoryrecord21=None, faulthistoryrecord22=None, faulthistoryrecord23=None, faulthistoryrecord24=None, faulthistoryrecord25=None, faulthistoryrecord26=None, faulthistoryrecord27=None, faulthistoryrecord28=None, faulthistoryrecord29=None, faulthistoryrecord30=None, faulthistoryrecord31=None, faulthistoryrecord00_time=None, faulthistoryrecord01_time=None, faulthistoryrecord02_time=None, faulthistoryrecord03_time=None, faulthistoryrecord04_time=None, faulthistoryrecord05_time=None, faulthistoryrecord06_time=None, faulthistoryrecord07_time=None, faulthistoryrecord08_time=None, faulthistoryrecord09_time=None, faulthistoryrecord10_time=None, faulthistoryrecord11_time=None, faulthistoryrecord12_time=None, faulthistoryrecord13_time=None, faulthistoryrecord14_time=None, faulthistoryrecord15_time=None, faulthistoryrecord16_time=None, faulthistoryrecord17_time=None, faulthistoryrecord18_time=None, faulthistoryrecord19_time=None, faulthistoryrecord20_time=None, faulthistoryrecord21_time=None, faulthistoryrecord22_time=None, faulthistoryrecord23_time=None, faulthistoryrecord24_time=None, faulthistoryrecord25_time=None, faulthistoryrecord26_time=None, faulthistoryrecord27_time=None, faulthistoryrecord28_time=None, faulthistoryrecord29_time=None, faulthistoryrecord30_time=None, faulthistoryrecord31_time=None

## settings

Filas: **2,284,775** · Columnas: **176**

Rango de columnas de tiempo:

- `read_ts`: de 1752327095.265811 (2025-07-12 13:31:35 UTC, época en s) a 1783919633.451776 (2026-07-13 05:13:53 UTC, época en s)
- `gridovdelaytime1`: de 0.12 a 0.12
- `gridovdelaytime2`: de 0.12 a 0.12
- `griduvdelaytime1`: de 1.5 a 1.5
- `griduvdelaytime2`: de 0.0 a 0.0
- `gridofdelaytime1`: de 0.1 a 0.1
- `gridofdelaytime2`: de 0.1 a 0.1
- `gridufdelaytime1`: de 0.1 a 0.1
- `gridufdelaytime2`: de 0.1 a 0.1
- `startongriddelay`: de 60.0 a 60.0
- `cvchgtimeset`: de 120 a 120
- `battdelayofftime`: de 30 a 30
- `ontimechargeen`: de 0 a 0
- `chargestarttime1`: de 0 a 0
- `chargeendtime1`: de 0 a 0
- `chargestarttime2`: de 0 a 0
- `chargeendtime2`: de 0 a 0
- `chargestarttime3`: de 0 a 0
- `chargeendtime3`: de 0 a 0
- `ontimedischgen`: de 0 a 0
- `dischgstarttime1`: de 0 a 0
- `dischgendtime1`: de 0 a 0
- `dischgstarttime2`: de 0 a 0
- `dischgendtime2`: de 0 a 0
- `dischgstarttime3`: de 0 a 0
- `dischgendtime3`: de 0 a 0
- `fp_of_start`: de 0.0 a 0.0
- `fp_uf_start`: de 0.0 a 0.0
- `fp_of_end`: de 0.0 a 0.0
- `fp_uf_end`: de 0.0 a 0.0
- `hvrt_level1time`: de 0.0 a 0.0
- `hvrt_level2time`: de 0.0 a 0.0
- `hvrt_level3time`: de 0.0 a 0.0
- `lvrt_level1time`: de 0.0 a 0.0
- `lvrt_level2time`: de 0.0 a 0.0
- `lvrt_level3time`: de 0.0 a 0.0
- `presenttime`: de 1752583208.480223 (2025-07-15 12:40:08 UTC, época en s) a 1783919526.662566 (2026-07-13 05:12:06 UTC, época en s)

| Columna | Tipo | % nulos |
|---|---|---:|
| read_ts | REAL | 0.0 |
| inverter | INTEGER | 0.0 |
| outpriority | INTEGER | 2.6 |
| outvoltset | REAL | 2.6 |
| outfreqset | REAL | 2.6 |
| linerangeset | INTEGER | 2.6 |
| paramodeset | INTEGER | 2.6 |
| ecoen | INTEGER | 2.6 |
| chgpriority | INTEGER | 2.6 |
| maxchgcurrset | REAL | 2.6 |
| chgcurrbypvset | REAL | 2.6 |
| chgcurrbylineset | REAL | 2.6 |
| commidset | INTEGER | 2.6 |
| muteen | INTEGER | 2.6 |
| ongirdset | INTEGER | 2.6 |
| chgfullcurrset | REAL | 2.6 |
| ng_funcen | INTEGER | 2.6 |
| leakagechecken | INTEGER | 95.9 |
| userpassword | INTEGER | 95.9 |
| passwordset | INTEGER | 95.9 |
| ctrlflag1 | INTEGER | 2.6 |
| battactiveset | INTEGER | 2.6 |
| ongridactivepowerset | INTEGER | 2.6 |
| ongridreactivepowerset | INTEGER | 2.6 |
| hybirdpriorityen | INTEGER | 2.6 |
| ongridpfset | REAL | 2.6 |
| gridstandardset | INTEGER | 2.6 |
| isodetecten | INTEGER | 2.6 |
| lowisovalue | INTEGER | 2.6 |
| maxlinepower | INTEGER | 2.6 |
| extctgethosten | INTEGER | 2.6 |
| outphasediffset | INTEGER | 2.6 |
| powerturboen | INTEGER | 2.6 |
| acoverlaodrestaren | INTEGER | 2.6 |
| gridconnectvoltmax | INTEGER | 2.6 |
| gridconnectvoltmin | INTEGER | 2.6 |
| gridconnectfreqmax | REAL | 2.6 |
| gridconnectfreqmin | REAL | 2.6 |
| gridreconnectvoltmax | INTEGER | 2.6 |
| gridreconnectvoltmin | INTEGER | 2.6 |
| gridreconnectfreqmax | REAL | 2.6 |
| gridreconnectfreqmin | REAL | 2.6 |
| gridovlevel1 | INTEGER | 2.6 |
| gridovdelaytime1 | REAL | 2.6 |
| gridovlevel2 | INTEGER | 2.5 |
| gridovdelaytime2 | REAL | 2.5 |
| griduvlevel1 | INTEGER | 2.6 |
| griduvdelaytime1 | REAL | 2.6 |
| griduvlevel2 | INTEGER | 2.6 |
| griduvdelaytime2 | REAL | 2.5 |
| ov10minprotectvalue | INTEGER | 2.6 |
| gridoflevel1 | REAL | 2.6 |
| gridofdelaytime1 | REAL | 2.6 |
| gridoflevel2 | REAL | 2.6 |
| gridofdelaytime2 | REAL | 2.6 |
| griduflevel1 | REAL | 2.6 |
| gridufdelaytime1 | REAL | 2.5 |
| griduflevel2 | REAL | 2.6 |
| gridufdelaytime2 | REAL | 2.6 |
| startongriddelay | REAL | 2.6 |
| loadingslope | INTEGER | 2.5 |
| ongridreconnectdelay | REAL | 2.6 |
| reloadingslope | INTEGER | 2.6 |
| powerdynamicrate | INTEGER | 2.6 |
| islanden | INTEGER | 2.6 |
| hvrten | INTEGER | 2.6 |
| lvrten | INTEGER | 2.6 |
| constreactpoweren | INTEGER | 2.6 |
| constpfen | INTEGER | 2.6 |
| f_pcurveen | INTEGER | 2.6 |
| p_qcurveen | INTEGER | 2.5 |
| u_pcurveen | INTEGER | 2.6 |
| u_qcurveen | INTEGER | 2.6 |
| drmen | INTEGER | 2.6 |
| remoteturnoffen | INTEGER | 2.6 |
| permitservice | INTEGER | 2.6 |
| reactpowerdynamicrate | INTEGER | 2.6 |
| reserve | TEXT | 0.3 |
| maxongridactivepower | INTEGER | 2.6 |
| maxlinecurr | REAL | 2.6 |
| smartmeterpower | INTEGER | 2.6 |
| battype | INTEGER | 95.9 |
| cvvolt | REAL | 2.6 |
| floatvolt | REAL | 2.6 |
| battovervolt | REAL | 2.6 |
| cvchgtimeset | INTEGER | 2.6 |
| cvchgbackvolt | REAL | 2.6 |
| inv2linevolt | REAL | 2.6 |
| lineback2invvolt | REAL | 2.6 |
| battlowvolt | REAL | 2.6 |
| battdelayoffvolt | REAL | 2.6 |
| batteodvolt | REAL | 2.6 |
| battdelayofftime | INTEGER | 2.6 |
| batteodbackvolt | REAL | 2.6 |
| bmsset | INTEGER | 2.6 |
| bmsprotocal | INTEGER | 2.6 |
| batsoclowalarm | INTEGER | 2.6 |
| batstopsoc | INTEGER | 2.6 |
| battfullsoc | INTEGER | 2.6 |
| inv2linesoc | INTEGER | 2.6 |
| lineback2invsoc | INTEGER | 2.6 |
| ontimechargeen | INTEGER | 2.6 |
| chargestarttime1 | INTEGER | 2.6 |
| chargeendtime1 | INTEGER | 2.6 |
| chargestarttime2 | INTEGER | 2.6 |
| chargeendtime2 | INTEGER | 2.6 |
| chargestarttime3 | INTEGER | 2.6 |
| chargeendtime3 | INTEGER | 2.6 |
| ontimedischgen | INTEGER | 2.6 |
| dischgstarttime1 | INTEGER | 2.6 |
| dischgendtime1 | INTEGER | 2.6 |
| dischgstarttime2 | INTEGER | 2.6 |
| dischgendtime2 | INTEGER | 2.6 |
| dischgstarttime3 | INTEGER | 2.6 |
| dischgendtime3 | INTEGER | 2.6 |
| battpacknotunion | INTEGER | 2.6 |
| forcechgstopsoc | INTEGER | 2.6 |
| battpackrateah | INTEGER | 2.6 |
| battsetreserve | TEXT | 0.2 |
| fp_of_start | REAL | 2.6 |
| fp_uf_start | REAL | 2.6 |
| fp_of_end | REAL | 2.6 |
| fp_uf_end | REAL | 2.6 |
| fp_of_dropslope | INTEGER | 2.6 |
| fp_uf_lodingslope | INTEGER | 2.6 |
| fp_actpowerresptr | REAL | 2.6 |
| pq_p1 | INTEGER | 2.6 |
| pq_q1 | INTEGER | 2.6 |
| pq_p2 | INTEGER | 2.6 |
| pq_q2 | INTEGER | 2.6 |
| pq_p3 | INTEGER | 2.6 |
| pq_q3 | INTEGER | 2.6 |
| pq_p1n | INTEGER | 2.6 |
| pq_q1n | INTEGER | 2.6 |
| pq_p2n | INTEGER | 2.6 |
| pq_q2n | INTEGER | 2.6 |
| pq_p3n | INTEGER | 2.6 |
| pq_q3n | INTEGER | 2.6 |
| pq_enablevolt | INTEGER | 2.6 |
| pq_disablevolt | INTEGER | 2.6 |
| up_v1 | INTEGER | 2.6 |
| up_p1 | INTEGER | 2.6 |
| up_v2 | INTEGER | 2.6 |
| up_p2 | INTEGER | 2.6 |
| up_actpowerresptr | REAL | 2.6 |
| up_v3 | INTEGER | 2.6 |
| up_p3 | INTEGER | 2.6 |
| up_v4 | INTEGER | 2.6 |
| up_p4 | INTEGER | 2.6 |
| uq_vref | INTEGER | 2.6 |
| uq_v1 | INTEGER | 2.6 |
| uq_q1 | INTEGER | 2.6 |
| uq_v2 | INTEGER | 2.6 |
| uq_q2 | INTEGER | 2.6 |
| uq_v3 | INTEGER | 2.6 |
| uq_q3 | INTEGER | 2.6 |
| uq_v4 | INTEGER | 2.6 |
| uq_q4 | INTEGER | 2.6 |
| uq_reactpowerresptr | REAL | 2.6 |
| uq_vrefautoen | INTEGER | 2.6 |
| uq_vrefresptr | REAL | 2.6 |
| uq_enablepower | INTEGER | 2.6 |
| uq_disablepower | INTEGER | 2.6 |
| hvrt_level1 | INTEGER | 2.6 |
| hvrt_level1time | REAL | 2.6 |
| hvrt_level2 | INTEGER | 2.6 |
| hvrt_level2time | REAL | 2.6 |
| hvrt_level3 | INTEGER | 2.6 |
| hvrt_level3time | REAL | 2.6 |
| lvrt_level1 | INTEGER | 2.6 |
| lvrt_level1time | REAL | 2.6 |
| lvrt_level2 | INTEGER | 2.6 |
| lvrt_level2time | REAL | 2.6 |
| lvrt_level3 | INTEGER | 2.6 |
| lvrt_level3time | REAL | 2.6 |
| presenttime | REAL | 3.5 |

Muestra (3 filas):

- read_ts=1752327095.265811, inverter=1, outpriority=None, outvoltset=None, outfreqset=None, linerangeset=None, paramodeset=None, ecoen=None, chgpriority=None, maxchgcurrset=None, chgcurrbypvset=None, chgcurrbylineset=None, commidset=None, muteen=None, ongirdset=None, chgfullcurrset=None, ng_funcen=None, leakagechecken=None, userpassword=None, passwordset=None, ctrlflag1=None, battactiveset=None, ongridactivepowerset=None, ongridreactivepowerset=None, hybirdpriorityen=None, ongridpfset=None, gridstandardset=None, isodetecten=None, lowisovalue=None, maxlinepower=None, extctgethosten=None, outphasediffset=None, powerturboen=None, acoverlaodrestaren=None, gridconnectvoltmax=None, gridconnectvoltmin=None, gridconnectfreqmax=None, gridconnectfreqmin=None, gridreconnectvoltmax=None, gridreconnectvoltmin=None, gridreconnectfreqmax=None, gridreconnectfreqmin=None, gridovlevel1=None, gridovdelaytime1=None, gridovlevel2=None, gridovdelaytime2=None, griduvlevel1=None, griduvdelaytime1=None, griduvlevel2=None, griduvdelaytime2=None, ov10minprotectvalue=None, gridoflevel1=None, gridofdelaytime1=None, gridoflevel2=None, gridofdelaytime2=None, griduflevel1=None, gridufdelaytime1=None, griduflevel2=None, gridufdelaytime2=None, startongriddelay=None, loadingslope=None, ongridreconnectdelay=None, reloadingslope=None, powerdynamicrate=None, islanden=None, hvrten=None, lvrten=None, constreactpoweren=None, constpfen=None, f_pcurveen=None, p_qcurveen=None, u_pcurveen=None, u_qcurveen=None, drmen=None, remoteturnoffen=None, permitservice=None, reactpowerdynamicrate=None, reserve=None, maxongridactivepower=None, maxlinecurr=None, smartmeterpower=None, battype=None, cvvolt=None, floatvolt=None, battovervolt=None, cvchgtimeset=None, cvchgbackvolt=None, inv2linevolt=None, lineback2invvolt=None, battlowvolt=None, battdelayoffvolt=None, batteodvolt=None, battdelayofftime=None, batteodbackvolt=None, bmsset=None, bmsprotocal=None, batsoclowalarm=None, batstopsoc=None, battfullsoc=None, inv2linesoc=None, lineback2invsoc=None, ontimechargeen=None, chargestarttime1=None, chargeendtime1=None, chargestarttime2=None, chargeendtime2=None, chargestarttime3=None, chargeendtime3=None, ontimedischgen=None, dischgstarttime1=None, dischgendtime1=None, dischgstarttime2=None, dischgendtime2=None, dischgstarttime3=None, dischgendtime3=None, battpacknotunion=None, forcechgstopsoc=None, battpackrateah=None, battsetreserve=None, fp_of_start=None, fp_uf_start=None, fp_of_end=None, fp_uf_end=None, fp_of_dropslope=None, fp_uf_lodingslope=None, fp_actpowerresptr=None, pq_p1=None, pq_q1=None, pq_p2=None, pq_q2=None, pq_p3=None, pq_q3=None, pq_p1n=None, pq_q1n=None, pq_p2n=None, pq_q2n=None, pq_p3n=None, pq_q3n=None, pq_enablevolt=None, pq_disablevolt=None, up_v1=None, up_p1=None, up_v2=None, up_p2=None, up_actpowerresptr=None, up_v3=None, up_p3=None, up_v4=None, up_p4=None, uq_vref=None, uq_v1=None, uq_q1=None, uq_v2=None, uq_q2=None, uq_v3=None, uq_q3=None, uq_v4=None, uq_q4=None, uq_reactpowerresptr=None, uq_vrefautoen=None, uq_vrefresptr=None, uq_enablepower=None, uq_disablepower=None, hvrt_level1=None, hvrt_level1time=None, hvrt_level2=None, hvrt_level2time=None, hvrt_level3=None, hvrt_level3time=None, lvrt_level1=None, lvrt_level1time=None, lvrt_level2=None, lvrt_level2time=None, lvrt_level3=None, lvrt_level3time=None, presenttime=None
- read_ts=1752327425.972802, inverter=1, outpriority=None, outvoltset=None, outfreqset=None, linerangeset=None, paramodeset=None, ecoen=None, chgpriority=None, maxchgcurrset=None, chgcurrbypvset=None, chgcurrbylineset=None, commidset=None, muteen=None, ongirdset=None, chgfullcurrset=None, ng_funcen=None, leakagechecken=None, userpassword=None, passwordset=None, ctrlflag1=None, battactiveset=None, ongridactivepowerset=None, ongridreactivepowerset=None, hybirdpriorityen=None, ongridpfset=None, gridstandardset=None, isodetecten=None, lowisovalue=None, maxlinepower=None, extctgethosten=None, outphasediffset=None, powerturboen=None, acoverlaodrestaren=None, gridconnectvoltmax=None, gridconnectvoltmin=None, gridconnectfreqmax=None, gridconnectfreqmin=None, gridreconnectvoltmax=None, gridreconnectvoltmin=None, gridreconnectfreqmax=None, gridreconnectfreqmin=None, gridovlevel1=None, gridovdelaytime1=None, gridovlevel2=None, gridovdelaytime2=None, griduvlevel1=None, griduvdelaytime1=None, griduvlevel2=None, griduvdelaytime2=None, ov10minprotectvalue=None, gridoflevel1=None, gridofdelaytime1=None, gridoflevel2=None, gridofdelaytime2=None, griduflevel1=None, gridufdelaytime1=None, griduflevel2=None, gridufdelaytime2=None, startongriddelay=None, loadingslope=None, ongridreconnectdelay=None, reloadingslope=None, powerdynamicrate=None, islanden=None, hvrten=None, lvrten=None, constreactpoweren=None, constpfen=None, f_pcurveen=None, p_qcurveen=None, u_pcurveen=None, u_qcurveen=None, drmen=None, remoteturnoffen=None, permitservice=None, reactpowerdynamicrate=None, reserve=None, maxongridactivepower=None, maxlinecurr=None, smartmeterpower=None, battype=None, cvvolt=None, floatvolt=None, battovervolt=None, cvchgtimeset=None, cvchgbackvolt=None, inv2linevolt=None, lineback2invvolt=None, battlowvolt=None, battdelayoffvolt=None, batteodvolt=None, battdelayofftime=None, batteodbackvolt=None, bmsset=None, bmsprotocal=None, batsoclowalarm=None, batstopsoc=None, battfullsoc=None, inv2linesoc=None, lineback2invsoc=None, ontimechargeen=None, chargestarttime1=None, chargeendtime1=None, chargestarttime2=None, chargeendtime2=None, chargestarttime3=None, chargeendtime3=None, ontimedischgen=None, dischgstarttime1=None, dischgendtime1=None, dischgstarttime2=None, dischgendtime2=None, dischgstarttime3=None, dischgendtime3=None, battpacknotunion=None, forcechgstopsoc=None, battpackrateah=None, battsetreserve=None, fp_of_start=None, fp_uf_start=None, fp_of_end=None, fp_uf_end=None, fp_of_dropslope=None, fp_uf_lodingslope=None, fp_actpowerresptr=None, pq_p1=None, pq_q1=None, pq_p2=None, pq_q2=None, pq_p3=None, pq_q3=None, pq_p1n=None, pq_q1n=None, pq_p2n=None, pq_q2n=None, pq_p3n=None, pq_q3n=None, pq_enablevolt=None, pq_disablevolt=None, up_v1=None, up_p1=None, up_v2=None, up_p2=None, up_actpowerresptr=None, up_v3=None, up_p3=None, up_v4=None, up_p4=None, uq_vref=None, uq_v1=None, uq_q1=None, uq_v2=None, uq_q2=None, uq_v3=None, uq_q3=None, uq_v4=None, uq_q4=None, uq_reactpowerresptr=None, uq_vrefautoen=None, uq_vrefresptr=None, uq_enablepower=None, uq_disablepower=None, hvrt_level1=None, hvrt_level1time=None, hvrt_level2=None, hvrt_level2time=None, hvrt_level3=None, hvrt_level3time=None, lvrt_level1=None, lvrt_level1time=None, lvrt_level2=None, lvrt_level2time=None, lvrt_level3=None, lvrt_level3time=None, presenttime=None
- read_ts=1752327755.42266, inverter=1, outpriority=None, outvoltset=None, outfreqset=None, linerangeset=None, paramodeset=None, ecoen=None, chgpriority=None, maxchgcurrset=None, chgcurrbypvset=None, chgcurrbylineset=None, commidset=None, muteen=None, ongirdset=None, chgfullcurrset=None, ng_funcen=None, leakagechecken=None, userpassword=None, passwordset=None, ctrlflag1=None, battactiveset=None, ongridactivepowerset=None, ongridreactivepowerset=None, hybirdpriorityen=None, ongridpfset=None, gridstandardset=None, isodetecten=None, lowisovalue=None, maxlinepower=None, extctgethosten=None, outphasediffset=None, powerturboen=None, acoverlaodrestaren=None, gridconnectvoltmax=None, gridconnectvoltmin=None, gridconnectfreqmax=None, gridconnectfreqmin=None, gridreconnectvoltmax=None, gridreconnectvoltmin=None, gridreconnectfreqmax=None, gridreconnectfreqmin=None, gridovlevel1=None, gridovdelaytime1=None, gridovlevel2=None, gridovdelaytime2=None, griduvlevel1=None, griduvdelaytime1=None, griduvlevel2=None, griduvdelaytime2=None, ov10minprotectvalue=None, gridoflevel1=None, gridofdelaytime1=None, gridoflevel2=None, gridofdelaytime2=None, griduflevel1=None, gridufdelaytime1=None, griduflevel2=None, gridufdelaytime2=None, startongriddelay=None, loadingslope=None, ongridreconnectdelay=None, reloadingslope=None, powerdynamicrate=None, islanden=None, hvrten=None, lvrten=None, constreactpoweren=None, constpfen=None, f_pcurveen=None, p_qcurveen=None, u_pcurveen=None, u_qcurveen=None, drmen=None, remoteturnoffen=None, permitservice=None, reactpowerdynamicrate=None, reserve=None, maxongridactivepower=None, maxlinecurr=None, smartmeterpower=None, battype=None, cvvolt=None, floatvolt=None, battovervolt=None, cvchgtimeset=None, cvchgbackvolt=None, inv2linevolt=None, lineback2invvolt=None, battlowvolt=None, battdelayoffvolt=None, batteodvolt=None, battdelayofftime=None, batteodbackvolt=None, bmsset=None, bmsprotocal=None, batsoclowalarm=None, batstopsoc=None, battfullsoc=None, inv2linesoc=None, lineback2invsoc=None, ontimechargeen=None, chargestarttime1=None, chargeendtime1=None, chargestarttime2=None, chargeendtime2=None, chargestarttime3=None, chargeendtime3=None, ontimedischgen=None, dischgstarttime1=None, dischgendtime1=None, dischgstarttime2=None, dischgendtime2=None, dischgstarttime3=None, dischgendtime3=None, battpacknotunion=None, forcechgstopsoc=None, battpackrateah=None, battsetreserve=None, fp_of_start=None, fp_uf_start=None, fp_of_end=None, fp_uf_end=None, fp_of_dropslope=None, fp_uf_lodingslope=None, fp_actpowerresptr=None, pq_p1=None, pq_q1=None, pq_p2=None, pq_q2=None, pq_p3=None, pq_q3=None, pq_p1n=None, pq_q1n=None, pq_p2n=None, pq_q2n=None, pq_p3n=None, pq_q3n=None, pq_enablevolt=None, pq_disablevolt=None, up_v1=None, up_p1=None, up_v2=None, up_p2=None, up_actpowerresptr=None, up_v3=None, up_p3=None, up_v4=None, up_p4=None, uq_vref=None, uq_v1=None, uq_q1=None, uq_v2=None, uq_q2=None, uq_v3=None, uq_q3=None, uq_v4=None, uq_q4=None, uq_reactpowerresptr=None, uq_vrefautoen=None, uq_vrefresptr=None, uq_enablepower=None, uq_disablepower=None, hvrt_level1=None, hvrt_level1time=None, hvrt_level2=None, hvrt_level2time=None, hvrt_level3=None, hvrt_level3time=None, lvrt_level1=None, lvrt_level1time=None, lvrt_level2=None, lvrt_level2time=None, lvrt_level3=None, lvrt_level3time=None, presenttime=None

## specs

Filas: **1,333,174** · Columnas: **16**

Rango de columnas de tiempo:

- `read_ts`: de 1752327095.265811 (2025-07-12 13:31:35 UTC, época en s) a 1770057630.734813 (2026-02-02 18:40:30 UTC, época en s)
- `cpubuidtime`: de [74,117,108,32,32,49,32,50,48,50,53,32,50,50,58,50,56,58,49,50] a [null]

| Columna | Tipo | % nulos |
|---|---|---:|
| read_ts | REAL | 0.0 |
| inverter | INTEGER | 0.0 |
| machcode | INTEGER | 92.9 |
| producttype | INTEGER | 92.9 |
| manufacturename | TEXT | 93.0 |
| sourcesn | TEXT | 93.1 |
| hwver_m1 | INTEGER | 92.9 |
| hwver_m2 | INTEGER | 93.0 |
| hwver_s1 | INTEGER | 92.9 |
| hwver_s2 | INTEGER | 93.0 |
| protocolver | INTEGER | 92.9 |
| bmsver | INTEGER | 93.0 |
| libver | TEXT | 93.0 |
| cpubuidtime | TEXT | 0.5 |
| customsn | TEXT | 0.5 |
| prdreserve | TEXT | 99.9 |

Muestra (3 filas):

- read_ts=1752327095.265811, inverter=1, machcode=None, producttype=None, manufacturename=None, sourcesn=None, hwver_m1=None, hwver_m2=None, hwver_s1=None, hwver_s2=None, protocolver=None, bmsver=None, libver=None, cpubuidtime=None, customsn=None, prdreserve=None
- read_ts=1752327425.972802, inverter=1, machcode=None, producttype=None, manufacturename=None, sourcesn=None, hwver_m1=None, hwver_m2=None, hwver_s1=None, hwver_s2=None, protocolver=None, bmsver=None, libver=None, cpubuidtime=None, customsn=None, prdreserve=None
- read_ts=1752327755.42266, inverter=1, machcode=None, producttype=None, manufacturename=None, sourcesn=None, hwver_m1=None, hwver_m2=None, hwver_s1=None, hwver_s2=None, protocolver=None, bmsver=None, libver=None, cpubuidtime=None, customsn=None, prdreserve=None

## statistics

Filas: **2,285,904** · Columnas: **31**

Rango de columnas de tiempo:

- `read_ts`: de 1752327095.265811 (2025-07-12 13:31:35 UTC, época en s) a 1783919633.451776 (2026-07-13 05:13:53 UTC, época en s)
- `invworktimetoday`: de 0 a 24
- `lineworktimetoday`: de 0 a 24
- `invworktimetotal`: de 0 a 3840
- `lineworktimetotal`: de 0 a 3225
- `powerontime`: de 1752896895.537227 (2025-07-19 03:48:15 UTC, época en s) a 1781588477.259869 (2026-06-16 05:41:17 UTC, época en s)
- `stactimeback`: de 1752512456.480223 (2025-07-14 17:00:56 UTC, época en s) a 1783868767.472918 (2026-07-12 15:06:07 UTC, época en s)

| Columna | Tipo | % nulos |
|---|---|---:|
| read_ts | REAL | 0.0 |
| inverter | INTEGER | 0.0 |
| batchgenergylast7day | TEXT | 0.2 |
| batdischgenergylast7day | TEXT | 0.2 |
| linechgenergylast7day | TEXT | 0.2 |
| loadconsumlast7day | TEXT | 0.2 |
| loadconsumfromlinelast7day | TEXT | 0.2 |
| energyreserved0 | TEXT | 0.1 |
| generatedacpowertoday | REAL | 2.6 |
| batchgenergytoday | REAL | 2.6 |
| batdischgenergytoday | REAL | 2.5 |
| pvgeneratenergytoday | REAL | 2.6 |
| usedenergytoday | REAL | 2.5 |
| workdaystotal | INTEGER | 2.6 |
| batchgenergytotal | TEXT | 0.1 |
| batdischgenergytotal | TEXT | 0.1 |
| pvgeneratenergytotal | TEXT | 0.1 |
| usedenergytotal | TEXT | 0.1 |
| linechgenergytday | REAL | 2.6 |
| loadconsumlinetday | REAL | 2.6 |
| invworktimetoday | INTEGER | 2.5 |
| lineworktimetoday | INTEGER | 2.6 |
| linechgenergytotal | TEXT | 0.2 |
| loadconsumlinetotal | TEXT | 0.1 |
| invworktimetotal | INTEGER | 2.6 |
| lineworktimetotal | INTEGER | 2.6 |
| generatedacpowertotal | TEXT | 0.1 |
| energyreserved2 | REAL | 2.6 |
| energyreserved1 | TEXT | 0.2 |
| powerontime | REAL | 54.5 |
| stactimeback | REAL | 3.6 |

Muestra (3 filas):

- read_ts=1756476868.327567, inverter=1, batchgenergylast7day=[0.0,0.0,0.0,0.0,0.0,0.0,0.0], batdischgenergylast7day=[0.0,0.0,0.0,0.0,0.0,0.0,0.0], linechgenergylast7day=[0.0,0.0,0.0,0.0,0.0,0.0,0.0], loadconsumlast7day=[0.0,0.0,0.0,0.0,0.0,0.0,0.0], loadconsumfromlinelast7day=[0.0,0.0,0.0,0.0,0.0,0.0,0.0], energyreserved0=[0.0,0.0], generatedacpowertoday=0.0, batchgenergytoday=4.5, batdischgenergytoday=0.1, pvgeneratenergytoday=0.1, usedenergytoday=0.7, workdaystotal=0, batchgenergytotal=[4.5,0.0], batdischgenergytotal=[0.1,0.0], pvgeneratenergytotal=[0.1,0.0], usedenergytotal=[0.7,0.0], linechgenergytday=4.5, loadconsumlinetday=0.5, invworktimetoday=0, lineworktimetoday=3, linechgenergytotal=[4.5,0.0], loadconsumlinetotal=[0.5,0.0], invworktimetotal=0, lineworktimetotal=3, generatedacpowertotal=[0.0,0.0], energyreserved2=0.0, energyreserved1=[0.0,0.0,0.0,0.0,0.0,0.0,0.0], powerontime=1756455152.882613, stactimeback=None
- read_ts=1756482071.193921, inverter=1, batchgenergylast7day=[0.0,0.0,0.0,0.0,0.0,0.0,0.0], batdischgenergylast7day=[0.0,0.0,0.0,0.0,0.0,0.0,0.0], linechgenergylast7day=[0.0,0.0,0.0,0.0,0.0,0.0,0.0], loadconsumlast7day=[0.0,0.0,0.0,0.0,0.0,0.0,0.0], loadconsumfromlinelast7day=[0.0,0.0,0.0,0.0,0.0,0.0,0.0], energyreserved0=[0.0,0.0], generatedacpowertoday=0.0, batchgenergytoday=5.0, batdischgenergytoday=0.1, pvgeneratenergytoday=0.1, usedenergytoday=0.9, workdaystotal=0, batchgenergytotal=[5.0,0.0], batdischgenergytotal=[0.1,0.0], pvgeneratenergytotal=[0.1,0.0], usedenergytotal=[0.9,0.0], linechgenergytday=5.0, loadconsumlinetday=0.7, invworktimetoday=0, lineworktimetoday=4, linechgenergytotal=[5.0,0.0], loadconsumlinetotal=[0.7,0.0], invworktimetotal=0, lineworktimetotal=4, generatedacpowertotal=[0.0,0.0], energyreserved2=0.0, energyreserved1=[0.0,0.0,0.0,0.0,0.0,0.0,0.0], powerontime=1756455152.882613, stactimeback=None
- read_ts=1756497644.771247, inverter=1, batchgenergylast7day=[0.0,0.0,0.0,0.0,0.0,0.0,0.0], batdischgenergylast7day=[0.0,0.0,0.0,0.0,0.0,0.0,0.0], linechgenergylast7day=[0.0,0.0,0.0,0.0,0.0,0.0,0.0], loadconsumlast7day=[0.0,0.0,0.0,0.0,0.0,0.0,0.0], loadconsumfromlinelast7day=[0.0,0.0,0.0,0.0,0.0,0.0,0.0], energyreserved0=[0.0,0.0], generatedacpowertoday=0.0, batchgenergytoday=5.1, batdischgenergytoday=0.1, pvgeneratenergytoday=0.1, usedenergytoday=1.4, workdaystotal=0, batchgenergytotal=[5.1,0.0], batdischgenergytotal=[0.1,0.0], pvgeneratenergytotal=[0.1,0.0], usedenergytotal=[1.4,0.0], linechgenergytday=5.1, loadconsumlinetday=1.2, invworktimetoday=0, lineworktimetoday=9, linechgenergytotal=[5.1,0.0], loadconsumlinetotal=[1.2,0.0], invworktimetotal=0, lineworktimetotal=9, generatedacpowertotal=[0.0,0.0], energyreserved2=0.0, energyreserved1=[0.0,0.0,0.0,0.0,0.0,0.0,0.0], powerontime=1756455152.882613, stactimeback=None

## status

Filas: **2,240,052** · Columnas: **20**

Rango de columnas de tiempo:

- `read_ts`: de 1752327095.265811 (2025-07-12 13:31:35 UTC, época en s) a 1783919633.451776 (2026-07-13 05:13:53 UTC, época en s)
- `startupstatus`: de 1 a 3

| Columna | Tipo | % nulos |
|---|---|---:|
| read_ts | REAL | 0.0 |
| inverter | INTEGER | 0.0 |
| startupstatus | INTEGER | 2.6 |
| outstatus | INTEGER | 2.6 |
| chgstatus | INTEGER | 2.6 |
| paramode | INTEGER | 2.6 |
| ecomode | INTEGER | 2.6 |
| battselfcheck | INTEGER | 2.6 |
| drycontact1 | INTEGER | 2.6 |
| drycontact2 | INTEGER | 2.6 |
| passwordstatus | INTEGER | 2.6 |
| sysstateflag | TEXT | 0.1 |
| sysalarmflag | TEXT | 0.1 |
| deroperationstate | INTEGER | 2.6 |
| derconnectstate | INTEGER | 2.6 |
| deralarmstatus | INTEGER | 2.6 |
| derinverterstate | INTEGER | 100.0 |
| derbattstate | INTEGER | 2.6 |
| remotectrlstatus | INTEGER | 2.6 |
| statusreserve | TEXT | 0.2 |

Muestra (3 filas):

- read_ts=1752327095.265811, inverter=1, startupstatus=None, outstatus=2, chgstatus=None, paramode=0, ecomode=0, battselfcheck=0, drycontact1=0, drycontact2=0, passwordstatus=4, sysstateflag=[382,16,11776,12,0,0,0,0], sysalarmflag=None, deroperationstate=0, derconnectstate=0, deralarmstatus=0, derinverterstate=0, derbattstate=0, remotectrlstatus=0, statusreserve=[0,0,0,0,0,0,0,0,0]
- read_ts=1752327425.972802, inverter=1, startupstatus=3, outstatus=2, chgstatus=0, paramode=0, ecomode=0, battselfcheck=0, drycontact1=0, drycontact2=0, passwordstatus=4, sysstateflag=[382,16,11776,12,0,0,0,0], sysalarmflag=[0,0,0,0,0,0,0,0], deroperationstate=None, derconnectstate=0, deralarmstatus=None, derinverterstate=0, derbattstate=0, remotectrlstatus=None, statusreserve=[0,0,0,0,0,0,0,0,0]
- read_ts=1752327755.42266, inverter=1, startupstatus=3, outstatus=2, chgstatus=0, paramode=0, ecomode=0, battselfcheck=0, drycontact1=0, drycontact2=0, passwordstatus=None, sysstateflag=[382,16,11776,12,0,0,0,0], sysalarmflag=[0,0,0,0,0,0,0,0], deroperationstate=0, derconnectstate=0, deralarmstatus=0, derinverterstate=0, derbattstate=0, remotectrlstatus=0, statusreserve=[0,0,0,0,0,0,0,0,0]

## totals

Filas: **2,279,918** · Columnas: **21**

Rango de columnas de tiempo:

- `read_ts`: de 1752327095.265811 (2025-07-12 13:31:35 UTC, época en s) a 1783919633.451776 (2026-07-13 05:13:53 UTC, época en s)

| Columna | Tipo | % nulos |
|---|---|---:|
| read_ts | REAL | 0.0 |
| inverter | INTEGER | 0.0 |
| alarmdetail | TEXT | 65.0 |
| bmsreqchgvolt | REAL | 99.7 |
| bmsreqeodvolt | REAL | 2.5 |
| bmsreqchgcurr | REAL | 2.5 |
| bmsreqdischgcurr | REAL | 2.5 |
| bmsreserve | TEXT | 0.1 |
| battsumpower | REAL | 2.6 |
| sys_battreserve | TEXT | 0.2 |
| extpvsumoutw_a | REAL | 2.5 |
| sys_pvreserve | TEXT | 0.2 |
| backupsumoutw_a | REAL | 2.5 |
| backupsumoutva_a | REAL | 2.5 |
| normalsumloadw_a | REAL | 2.5 |
| normalsumloadva_a | REAL | 2.5 |
| generatedsumpowerp_a | REAL | 2.5 |
| generatedsumpowers_a | REAL | 2.5 |
| sys_outreserve | TEXT | 0.1 |
| linesumpowerw_a | REAL | 2.6 |
| sys_linereserve | TEXT | 0.2 |

Muestra (3 filas):

- read_ts=1752327095.265811, inverter=1, alarmdetail=None, bmsreqchgvolt=57.6, bmsreqeodvolt=44.8, bmsreqchgcurr=180.0, bmsreqdischgcurr=180.0, bmsreserve=[0,0,0,0,0], battsumpower=None, sys_battreserve=[0,0,0,0,0,0,0,0,0], extpvsumoutw_a=0.0, sys_pvreserve=[0,0,0,0,0,0,0,0,0,0,0,0], backupsumoutw_a=None, backupsumoutva_a=0.0, normalsumloadw_a=0.0, normalsumloadva_a=0.0, generatedsumpowerp_a=0.0, generatedsumpowers_a=0.0, sys_outreserve=[0,0,0,0,0,0], linesumpowerw_a=0.0, sys_linereserve=None
- read_ts=1752327425.972802, inverter=1, alarmdetail=None, bmsreqchgvolt=57.6, bmsreqeodvolt=44.8, bmsreqchgcurr=180.0, bmsreqdischgcurr=180.0, bmsreserve=[0,0,0,0,0], battsumpower=None, sys_battreserve=[0,0,0,0,0,0,0,0,0], extpvsumoutw_a=None, sys_pvreserve=[0,0,0,0,0,0,0,0,0,0,0,0], backupsumoutw_a=0.0, backupsumoutva_a=0.0, normalsumloadw_a=0.0, normalsumloadva_a=0.0, generatedsumpowerp_a=0.0, generatedsumpowers_a=0.0, sys_outreserve=[0,0,0,0,0,0], linesumpowerw_a=0.0, sys_linereserve=[0,0,0,0,0,0,0,0,0,0,0]
- read_ts=1752327755.42266, inverter=1, alarmdetail=None, bmsreqchgvolt=57.6, bmsreqeodvolt=44.8, bmsreqchgcurr=180.0, bmsreqdischgcurr=180.0, bmsreserve=[0,0,0,0,0], battsumpower=None, sys_battreserve=[0,0,0,0,0,0,0,0,0], extpvsumoutw_a=0.0, sys_pvreserve=None, backupsumoutw_a=0.0, backupsumoutva_a=0.0, normalsumloadw_a=0.0, normalsumloadva_a=0.0, generatedsumpowerp_a=0.0, generatedsumpowers_a=0.0, sys_outreserve=[0,0,0,0,0,0], linesumpowerw_a=0.0, sys_linereserve=[0,0,0,0,0,0,0,0,0,0,0]
