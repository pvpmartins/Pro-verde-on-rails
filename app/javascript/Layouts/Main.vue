<template>
  <header class="bg-green-500 text-white py-4">
    <nav class="container mx-auto flex justify-between items-center">
      <!-- Slot for logo or title -->
      <slot name="logo">
        <h1 class="text-3xl font-bold">PlantStore</h1>
        <!-- Default content -->
      </slot>

      <!-- Slot for navigation links -->
      <slot name="nav">
        <ul class="flex space-x-4 items-center">
          <li><a href="#" class="hover:text-gray-200">Home</a></li>
          <li>
            <Link href="/plants" class="hover:text-gray-200">Plantas</Link>
          </li>
          <li v-if="currentUser"><Link href="/users/subscriptions" class="hover:text-gray-200">Subscriptions</Link></li>
          <li><a href="#" class="hover:text-gray-200">Contact</a></li>
          <Link v-if="!currentUser" href="/users/sign_in"><Button label="Login" class="m-0" @click="" /></Link>
          <div v-if="currentUser" class="rounded border px-2 py-1">{{ currentUser['first_name'] }}</div>
        </ul>
      </slot>
    </nav>
  </header>
  <slot></slot>
</template>

<script lang="ts" setup>
import { Link, router, usePage } from '@inertiajs/vue3'

const page = usePage()

const currentUser = page.props?.['current_user']

</script>

<style scoped>
/* Any additional styling */
</style>
