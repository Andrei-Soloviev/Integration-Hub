/*
  Warnings:

  - You are about to drop the column `responseBody` on the `delivery_attempt` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "delivery_attempt" DROP COLUMN "responseBody",
ADD COLUMN     "response_body" TEXT;
