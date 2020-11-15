-- 1. Поднимите нижнюю границу минимальной заработной платы в таблице JOB до
-- 1000$.
UPDATE JOB
SET MINSALARY = 1000
WHERE MINSALARY = (SELECT MIN(MINSALARY) FROM JOB);

-- 2. Поднимите минимальную зарплату в таблице JOB на 10% для всех
-- специальностей, кроме финансового директора.
UPDATE JOB
SET MINSALARY = MINSALARY * 0.1
WHERE JOBNAME != 'FINANCIAL DIRECTOR';
