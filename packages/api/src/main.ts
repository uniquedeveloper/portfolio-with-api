import express from 'express';
import {
  fetchers,
  getCache,
  getLlamaProtocolsJob,
  jobs, platforms, runFetcher
} from '@sonarwatch/portfolio-plugins';
import { isAddress, networks } from '@sonarwatch/portfolio-core';
import util from 'node:util';
import durationForHumans from "packages/plugins/src/utils/misc/durationForHumans";
import sleep from "packages/plugins/src/utils/misc/sleep";
import * as dotenv from 'dotenv';
import { resolve } from 'path';
import { json } from './utils';
import * as fs from 'node:fs';
import * as path from 'node:path';
import { Data } from 'osmojs/tendermint/types/types';

dotenv.config({ path: resolve(__dirname, '../../.env') });

const host = process.env['HOST'] ?? '0.0.0.0';
const port = process.env['PORT'] ? Number(process.env['PORT']) : 8080;

const app = express();


const api = express.Router();

const allJobs = [...jobs, getLlamaProtocolsJob(platforms)];

/**
 * @openapi
 * /run/health:
 *   get:
 *     tags: [API Healthcheck]
 *     description: Healthcheck endpoint
 *     responses:
 *       200:
 *         description: Server is healthy.
 *       500:
 *         description: Server is unhealthy. The reason will be specified under data.
 */
api.get('/health', (req, res) => {
  const missingEnvs: string[] = [];

  const solanaRpcEnv = process.env['PORTFOLIO_SOLANA_RPC']
  if (!solanaRpcEnv) {
    missingEnvs.push("PORTFOLIO_SOLANA_RPC")
  }
  const cacheConfigTypeEnv = process.env['CACHE_CONFIG_TYPE']
  if (!cacheConfigTypeEnv) {
    missingEnvs.push("CACHE_CONFIG_TYPE")
  }

  if (missingEnvs.length > 0) {
    return json(res, {
      status: 500,
      message: 'API server is unhealthy. Missing ENV variables',
      data: { missingEnvs }
    })
  }

  return json(res, {
    status: 200,
    message: 'API server is healthy.',
    data: {
      env: {
        CACHE_CONFIG_HTTP_BASE: process.env['CACHE_CONFIG_OVERLAY_HTTP_BASES'],
        CACHE_CONFIG_TYPE: process.env['CACHE_CONFIG_OVERLAY_HTTP_BASES']
      }
    }
  })
});

/**
 * @openapi
 * /jobs/{id}:
 *   get:
 *     tags: [Fetchers and Jobs]
 *     description: Runs a Job
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: The Job ID
 *     responses:
 *       200:
 *         description: Runs a Job
 */
api.get('/jobs/:id', async (req, res) => {
  try {
    const jobId = req.params.id;

    const job = allJobs.find((f) => f.id === jobId);
    if (!job) {
      return json(res, {
        status: 404,
        message: `Job cannot be found: ${jobId}`
      })
    }

    const cache = getCache();

    const startDate = Date.now();
    console.log(`Running job: ${jobId}`);
    await job.executor(cache);

    const duration = ((Date.now() - startDate) / 1000).toFixed(2);
    return json(res, {
      status: 200,
      message: `Finished (${duration}s)`
    })
  } catch (exception) {
    return json(res, {
      status: 500,
      message: 'Internal Server Error',
      exception
    })
  }
});

app.use('/run', api);

app.listen(port, host, () => {
  console.log(`[ ready ] http://${host}:${port}`);
});