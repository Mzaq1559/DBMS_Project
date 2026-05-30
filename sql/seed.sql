-- ============================================
-- RCMS Seed Data
-- ============================================

TRUNCATE invoices, reservations, customers, vehicles, locations RESTART IDENTITY CASCADE;

-- ============================================
-- Locations (3)
-- ============================================
INSERT INTO locations (name, address, city, phone) VALUES
('Downtown Branch', '123 Main St',   'Lahore', '042-1111111'),
('Airport Branch',  '45 Airport Rd', 'Lahore', '042-2222222'),
('Gulberg Branch',  '78 MM Alam Rd', 'Lahore', '042-3333333');

-- ============================================
-- Vehicles (50)
-- ============================================
INSERT INTO vehicles (location_id, make, model, year, vin, category, daily_rate, status) VALUES
(1,'Toyota','Corolla',2022,'VIN0000000000001','economy',5000.00,'available'),
(1,'Honda','City',2023,'VIN0000000000002','economy',5500.00,'available'),
(1,'Suzuki','Cultus',2021,'VIN0000000000003','economy',4000.00,'available'),
(1,'Suzuki','Alto',2022,'VIN0000000000004','economy',3500.00,'available'),
(1,'Toyota','Yaris',2023,'VIN0000000000005','economy',5200.00,'available'),
(1,'Honda','Civic',2023,'VIN0000000000006','economy',6000.00,'available'),
(1,'Kia','Picanto',2022,'VIN0000000000007','economy',4500.00,'available'),
(1,'Hyundai','Tucson',2022,'VIN0000000000008','suv',9000.00,'available'),
(1,'Toyota','Fortuner',2023,'VIN0000000000009','suv',12000.00,'available'),
(1,'Kia','Sportage',2023,'VIN0000000000010','suv',10000.00,'available'),
(2,'Toyota','Corolla',2021,'VIN0000000000011','economy',4800.00,'available'),
(2,'Honda','City',2022,'VIN0000000000012','economy',5200.00,'available'),
(2,'Suzuki','Cultus',2022,'VIN0000000000013','economy',4000.00,'available'),
(2,'Toyota','Yaris',2022,'VIN0000000000014','economy',5000.00,'available'),
(2,'Honda','Civic',2022,'VIN0000000000015','economy',5800.00,'available'),
(2,'Kia','Picanto',2023,'VIN0000000000016','economy',4600.00,'available'),
(2,'Suzuki','Swift',2023,'VIN0000000000017','economy',4200.00,'available'),
(2,'Hyundai','Tucson',2023,'VIN0000000000018','suv',9500.00,'available'),
(2,'Toyota','Fortuner',2022,'VIN0000000000019','suv',11500.00,'available'),
(2,'Kia','Sportage',2022,'VIN0000000000020','suv',9800.00,'available'),
(2,'MG','HS',2023,'VIN0000000000021','suv',11000.00,'available'),
(2,'Toyota','Land Cruiser',2022,'VIN0000000000022','suv',20000.00,'available'),
(2,'Honda','BRV',2023,'VIN0000000000023','suv',8500.00,'available'),
(2,'Toyota','Camry',2023,'VIN0000000000024','luxury',15000.00,'available'),
(2,'Honda','Accord',2022,'VIN0000000000025','luxury',14000.00,'available'),
(3,'Toyota','Corolla',2023,'VIN0000000000026','economy',5100.00,'available'),
(3,'Honda','City',2023,'VIN0000000000027','economy',5400.00,'available'),
(3,'Suzuki','Cultus',2023,'VIN0000000000028','economy',4100.00,'available'),
(3,'Toyota','Yaris',2023,'VIN0000000000029','economy',5100.00,'available'),
(3,'Honda','Civic',2023,'VIN0000000000030','economy',6100.00,'available'),
(3,'Kia','Picanto',2022,'VIN0000000000031','economy',4400.00,'available'),
(3,'Suzuki','Alto',2023,'VIN0000000000032','economy',3600.00,'available'),
(3,'Suzuki','Swift',2022,'VIN0000000000033','economy',4300.00,'available'),
(3,'Hyundai','Tucson',2022,'VIN0000000000034','suv',9200.00,'available'),
(3,'Toyota','Fortuner',2023,'VIN0000000000035','suv',12500.00,'available'),
(3,'Kia','Sportage',2023,'VIN0000000000036','suv',10500.00,'available'),
(3,'MG','HS',2022,'VIN0000000000037','suv',10800.00,'available'),
(3,'Toyota','Land Cruiser',2023,'VIN0000000000038','suv',21000.00,'available'),
(3,'Honda','BRV',2022,'VIN0000000000039','suv',8200.00,'available'),
(3,'Toyota','Camry',2022,'VIN0000000000040','luxury',14500.00,'available'),
(3,'Honda','Accord',2023,'VIN0000000000041','luxury',14500.00,'available'),
(1,'MG','HS',2023,'VIN0000000000042','suv',11200.00,'available'),
(1,'Toyota','Land Cruiser',2023,'VIN0000000000043','suv',21500.00,'available'),
(1,'Honda','BRV',2023,'VIN0000000000044','suv',8700.00,'available'),
(1,'Toyota','Camry',2023,'VIN0000000000045','luxury',15500.00,'available'),
(1,'Honda','Accord',2023,'VIN0000000000046','luxury',14800.00,'available'),
(1,'Suzuki','Swift',2023,'VIN0000000000047','economy',4400.00,'available'),
(2,'Suzuki','Alto',2023,'VIN0000000000048','economy',3700.00,'available'),
(1,'Changan','Alsvin',2023,'VIN0000000000049','economy',4600.00,'available'),
(2,'Changan','Alsvin',2022,'VIN0000000000050','economy',4400.00,'available');

-- ============================================
-- Customers (100)
-- ============================================
INSERT INTO customers (full_name, email, phone, license_no) VALUES
('Ali Hassan','ali.hassan@email.com','0300-1000001','LHR-001'),
('Sara Khan','sara.khan@email.com','0300-1000002','LHR-002'),
('Umar Farooq','umar.farooq@email.com','0300-1000003','LHR-003'),
('Ayesha Malik','ayesha.malik@email.com','0300-1000004','LHR-004'),
('Bilal Ahmed','bilal.ahmed@email.com','0300-1000005','LHR-005'),
('Fatima Zahra','fatima.zahra@email.com','0300-1000006','LHR-006'),
('Hamza Sheikh','hamza.sheikh@email.com','0300-1000007','LHR-007'),
('Zainab Qureshi','zainab.qureshi@email.com','0300-1000008','LHR-008'),
('Tariq Mehmood','tariq.mehmood@email.com','0300-1000009','LHR-009'),
('Nadia Hussain','nadia.hussain@email.com','0300-1000010','LHR-010'),
('Kashif Iqbal','kashif.iqbal@email.com','0300-1000011','LHR-011'),
('Sana Butt','sana.butt@email.com','0300-1000012','LHR-012'),
('Imran Raza','imran.raza@email.com','0300-1000013','LHR-013'),
('Hira Nawaz','hira.nawaz@email.com','0300-1000014','LHR-014'),
('Asad Javed','asad.javed@email.com','0300-1000015','LHR-015'),
('Maryam Siddiqui','maryam.siddiqui@email.com','0300-1000016','LHR-016'),
('Faisal Rehman','faisal.rehman@email.com','0300-1000017','LHR-017'),
('Rabia Yousuf','rabia.yousuf@email.com','0300-1000018','LHR-018'),
('Adnan Mirza','adnan.mirza@email.com','0300-1000019','LHR-019'),
('Saima Chaudhry','saima.chaudhry@email.com','0300-1000020','LHR-020'),
('Omer Khalid','omer.khalid@email.com','0300-1000021','LHR-021'),
('Lubna Aslam','lubna.aslam@email.com','0300-1000022','LHR-022'),
('Shahid Latif','shahid.latif@email.com','0300-1000023','LHR-023'),
('Amna Riaz','amna.riaz@email.com','0300-1000024','LHR-024'),
('Waqas Anwar','waqas.anwar@email.com','0300-1000025','LHR-025'),
('Uzma Bashir','uzma.bashir@email.com','0300-1000026','LHR-026'),
('Naveed Awan','naveed.awan@email.com','0300-1000027','LHR-027'),
('Rukhsana Gill','rukhsana.gill@email.com','0300-1000028','LHR-028'),
('Danish Saleem','danish.saleem@email.com','0300-1000029','LHR-029'),
('Shazia Baig','shazia.baig@email.com','0300-1000030','LHR-030'),
('Kamran Zafar','kamran.zafar@email.com','0300-1000031','LHR-031'),
('Tahira Naz','tahira.naz@email.com','0300-1000032','LHR-032'),
('Shahzad Rana','shahzad.rana@email.com','0300-1000033','LHR-033'),
('Fozia Hamid','fozia.hamid@email.com','0300-1000034','LHR-034'),
('Nasir Gondal','nasir.gondal@email.com','0300-1000035','LHR-035'),
('Bushra Nisar','bushra.nisar@email.com','0300-1000036','LHR-036'),
('Junaid Waheed','junaid.waheed@email.com','0300-1000037','LHR-037'),
('Madiha Iftikhar','madiha.iftikhar@email.com','0300-1000038','LHR-038'),
('Rizwan Ghani','rizwan.ghani@email.com','0300-1000039','LHR-039'),
('Samina Tariq','samina.tariq@email.com','0300-1000040','LHR-040'),
('Mudassar Hayat','mudassar.hayat@email.com','0300-1000041','LHR-041'),
('Nosheen Arif','nosheen.arif@email.com','0300-1000042','LHR-042'),
('Sajid Bhatti','sajid.bhatti@email.com','0300-1000043','LHR-043'),
('Kiran Shabbir','kiran.shabbir@email.com','0300-1000044','LHR-044'),
('Asif Cheema','asif.cheema@email.com','0300-1000045','LHR-045'),
('Naila Sarwar','naila.sarwar@email.com','0300-1000046','LHR-046'),
('Pervaiz Dar','pervaiz.dar@email.com','0300-1000047','LHR-047'),
('Ghazala Noor','ghazala.noor@email.com','0300-1000048','LHR-048'),
('Zubair Ansari','zubair.ansari@email.com','0300-1000049','LHR-049'),
('Farhat Bibi','farhat.bibi@email.com','0300-1000050','LHR-050'),
('Salman Babar','salman.babar@email.com','0300-1000051','LHR-051'),
('Iram Gul','iram.gul@email.com','0300-1000052','LHR-052'),
('Fahad Tanvir','fahad.tanvir@email.com','0300-1000053','LHR-053'),
('Sobia Akram','sobia.akram@email.com','0300-1000054','LHR-054'),
('Irfan Lodhi','irfan.lodhi@email.com','0300-1000055','LHR-055'),
('Mehwish Zahid','mehwish.zahid@email.com','0300-1000056','LHR-056'),
('Shoaib Naseer','shoaib.naseer@email.com','0300-1000057','LHR-057'),
('Amber Farhan','amber.farhan@email.com','0300-1000058','LHR-058'),
('Waseem Taj','waseem.taj@email.com','0300-1000059','LHR-059'),
('Nazia Sohail','nazia.sohail@email.com','0300-1000060','LHR-060'),
('Haroon Rashid','haroon.rashid@email.com','0300-1000061','LHR-061'),
('Sumera Altaf','sumera.altaf@email.com','0300-1000062','LHR-062'),
('Khurram Shehzad','khurram.shehzad@email.com','0300-1000063','LHR-063'),
('Yasmin Parveen','yasmin.parveen@email.com','0300-1000064','LHR-064'),
('Arif Mahmood','arif.mahmood@email.com','0300-1000065','LHR-065'),
('Zara Imtiaz','zara.imtiaz@email.com','0300-1000066','LHR-066'),
('Naeem Qazi','naeem.qazi@email.com','0300-1000067','LHR-067'),
('Huma Ejaz','huma.ejaz@email.com','0300-1000068','LHR-068'),
('Babar Sultan','babar.sultan@email.com','0300-1000069','LHR-069'),
('Samra Waqar','samra.waqar@email.com','0300-1000070','LHR-070'),
('Zeeshan Malik','zeeshan.malik@email.com','0300-1000071','LHR-071'),
('Shehla Rauf','shehla.rauf@email.com','0300-1000072','LHR-072'),
('Mohsin Karim','mohsin.karim@email.com','0300-1000073','LHR-073'),
('Aqsa Maqbool','aqsa.maqbool@email.com','0300-1000074','LHR-074'),
('Sohail Pirzada','sohail.pirzada@email.com','0300-1000075','LHR-075'),
('Romana Ilyas','romana.ilyas@email.com','0300-1000076','LHR-076'),
('Usman Qureshi','usman.qureshi@email.com','0300-1000077','LHR-077'),
('Fareeha Sajjad','fareeha.sajjad@email.com','0300-1000078','LHR-078'),
('Ahsan Butt','ahsan.butt@email.com','0300-1000079','LHR-079'),
('Tayyaba Noon','tayyaba.noon@email.com','0300-1000080','LHR-080'),
('Rehan Warraich','rehan.warraich@email.com','0300-1000081','LHR-081'),
('Uzma Faisal','uzma.faisal@email.com','0300-1000082','LHR-082'),
('Zahid Mansoor','zahid.mansoor@email.com','0300-1000083','LHR-083'),
('Parveen Asad','parveen.asad@email.com','0300-1000084','LHR-084'),
('Naseer Chishti','naseer.chishti@email.com','0300-1000085','LHR-085'),
('Humaira Zaheer','humaira.zaheer@email.com','0300-1000086','LHR-086'),
('Waqar Yousaf','waqar.yousaf@email.com','0300-1000087','LHR-087'),
('Sumaira Bano','sumaira.bano@email.com','0300-1000088','LHR-088'),
('Talha Usman','talha.usman@email.com','0300-1000089','LHR-089'),
('Nida Hafeez','nida.hafeez@email.com','0300-1000090','LHR-090'),
('Fawad Gillani','fawad.gillani@email.com','0300-1000091','LHR-091'),
('Saira Kamal','saira.kamal@email.com','0300-1000092','LHR-092'),
('Imtiaz Virk','imtiaz.virk@email.com','0300-1000093','LHR-093'),
('Raheela Zaman','raheela.zaman@email.com','0300-1000094','LHR-094'),
('Shahbaz Gill','shahbaz.gill@email.com','0300-1000095','LHR-095'),
('Riffat Munir','riffat.munir@email.com','0300-1000096','LHR-096'),
('Hamid Sultan','hamid.sultan@email.com','0300-1000097','LHR-097'),
('Afshan Malik','afshan.malik@email.com','0300-1000098','LHR-098'),
('Qaiser Mehmood','qaiser.mehmood@email.com','0300-1000099','LHR-099'),
('Lubna Wahab','lubna.wahab@email.com','0300-1000100','LHR-100');

-- ============================================
-- Reservations + Invoices (500)
-- Generated with non-overlapping date ranges per vehicle
-- All marked as completed (past dates)
-- ============================================
DO $$
DECLARE
  v_id INT;
  c_id INT;
  s_date DATE;
  e_date DATE;
  days INT;
  rate NUMERIC;
  sub NUMERIC;
  tax NUMERIC;
  tot NUMERIC;
  res_id INT;
  base_date DATE := DATE '2024-01-01';
  offset_days INT;
  counter INT := 0;
BEGIN
  FOR v_id IN 1..50 LOOP
    offset_days := 0;
    FOR i IN 1..10 LOOP
      c_id := ((v_id * 7 + i * 13) % 100) + 1;
      days := 2 + (i % 5);
      s_date := base_date + (offset_days || ' days')::INTERVAL;
      e_date := s_date + (days || ' days')::INTERVAL;
      offset_days := offset_days + days + 1;

      SELECT daily_rate INTO rate FROM vehicles WHERE vehicle_id = v_id;

      INSERT INTO reservations (customer_id, vehicle_id, start_date, end_date, status)
      VALUES (c_id, v_id, s_date, e_date, 'completed')
      RETURNING reservation_id INTO res_id;

      sub := days * rate;
      tax := ROUND(sub * 0.18, 2);
      tot := sub + tax;

      INSERT INTO invoices (reservation_id, subtotal, tax, total, paid)
      VALUES (res_id, sub, tax, tot, TRUE);

      counter := counter + 1;
    END LOOP;
  END LOOP;
  RAISE NOTICE 'Inserted % reservations', counter;
END $$;