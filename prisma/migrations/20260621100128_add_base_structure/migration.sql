-- CreateEnum
CREATE TYPE "HttpMethods" AS ENUM ('GET', 'POST', 'PUT', 'PATCH', 'DELETE');

-- CreateEnum
CREATE TYPE "BackoffStrategy" AS ENUM ('fixed', 'exponential');

-- CreateEnum
CREATE TYPE "DeadLetterRule" AS ENUM ('dead_letter', 'discard');

-- CreateEnum
CREATE TYPE "StatusEvent" AS ENUM ('pending', 'processing', 'delivered', 'failed', 'dead_letter');

-- CreateEnum
CREATE TYPE "DeliveryAttemptStatus" AS ENUM ('failed', 'delivered');

-- CreateTable
CREATE TABLE "integrations" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(250) NOT NULL,
    "target_url" VARCHAR(250) NOT NULL,
    "target_http_method" "HttpMethods" NOT NULL,
    "target_headers" JSONB,
    "max_retry_count" INTEGER NOT NULL DEFAULT 5,
    "backoff_strategy" "BackoffStrategy" NOT NULL,
    "dead_letter_rule" "DeadLetterRule" NOT NULL,
    "is_active" BOOLEAN NOT NULL,
    "incoming_path" VARCHAR(250) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "integrations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "events" (
    "id" SERIAL NOT NULL,
    "integration_id" INTEGER NOT NULL,
    "payload" JSONB NOT NULL,
    "status" "StatusEvent" NOT NULL DEFAULT 'pending',
    "attempt_count" INTEGER NOT NULL DEFAULT 0,
    "last_attempt_at" TIMESTAMP(3),
    "next_retry_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "delivery_attempt" (
    "id" SERIAL NOT NULL,
    "event_id" INTEGER NOT NULL,
    "attempt" INTEGER NOT NULL,
    "attempted_at" TIMESTAMP(3) NOT NULL,
    "status" "DeliveryAttemptStatus" NOT NULL,
    "http_status" INTEGER,
    "error_message" TEXT,
    "duration_ms" INTEGER NOT NULL,
    "responseBody" TEXT,

    CONSTRAINT "delivery_attempt_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "integrations_name_key" ON "integrations"("name");

-- CreateIndex
CREATE UNIQUE INDEX "integrations_incoming_path_key" ON "integrations"("incoming_path");

-- CreateIndex
CREATE INDEX "integrations_incoming_path_idx" ON "integrations"("incoming_path");

-- CreateIndex
CREATE INDEX "events_next_retry_at_idx" ON "events"("next_retry_at");

-- CreateIndex
CREATE INDEX "events_integration_id_idx" ON "events"("integration_id");

-- CreateIndex
CREATE INDEX "events_status_idx" ON "events"("status");

-- CreateIndex
CREATE INDEX "delivery_attempt_event_id_idx" ON "delivery_attempt"("event_id");

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_integration_id_fkey" FOREIGN KEY ("integration_id") REFERENCES "integrations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "delivery_attempt" ADD CONSTRAINT "delivery_attempt_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "events"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
