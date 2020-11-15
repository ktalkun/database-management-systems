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

-- 3. Поднимите минимальную зарплату в таблице JOB на 10% для клерков и на 20%
-- для финансового директора (одним оператором).
UPDATE JOB
SET MINSALARY =
        CASE
            WHEN JOBNAME = 'CLERK' THEN MINSALARY * 0.1
            WHEN JOBNAME = 'FINANCIAL DIRECTOR' THEN MINSALARY * 0.2
            END
WHERE JOBNAME = 'CLERK'
   OR JOBNAME = 'FINANCIAL DIRECTOR';
