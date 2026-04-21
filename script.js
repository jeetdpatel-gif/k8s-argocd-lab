// Harness/ArgoCD Secrets Test - Vanilla JS
(function() {
  'use strict';

  // Get build time
  document.getElementById('buildTime').textContent = new Date().toISOString();

  // Simulate pod name (in K8s would be from env)
  const podName = process?.env?.HOSTNAME || 'local-dev';
  document.getElementById('podName').textContent = podName;

  // Harness secret test - normally injected via K8s env var
  const appSecret = process?.env?.APP_SECRET || '*** HARNESS_SECRET_NOT_INJECTED ***';
  const harnessEnv = process?.env?.HARNESS_ENV || 'dev';
  
  document.getElementById('appSecret').textContent = appSecret.substring(0, 8) + '...';
  document.getElementById('harnessEnv').textContent = harnessEnv;

  // Toggle secret preview
  const toggleBtn = document.getElementById('toggleSecret');
  const preview = document.getElementById('secretPreview');
  const secretHashEl = document.getElementById('secretHash');
  
  let visible = false;
  toggleBtn.addEventListener('click', () => {
    visible = !visible;
    preview.classList.toggle('hidden');
    toggleBtn.textContent = visible ? 'Hide Secret Preview' : 'Show Secret Preview';
    if (visible) {
      // Show hash for demo (never show full secret!)
      secretHashEl.textContent = btoa(appSecret).substring(0, 20) + '...';
    }
  });

  // Countdown health check
  let count = 30;
  const countdownEl = document.getElementById('countdown');
  const timer = setInterval(() => {
    count--;
    countdownEl.textContent = count > 0 ? `${count}s` : '✅ Healthy';
    if (count <= 0) {
      clearInterval(timer);
      countdownEl.textContent = '✅ Healthy';
    }
  }, 1000);

  // Log for container logs
  console.log('AWS Exam POC loaded:', { podName, harnessEnv, secretLength: appSecret.length });
})();

