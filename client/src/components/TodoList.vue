<template>
  <v-container class="d-flex flex-column justify-center">
    <v-card min-width="450" class="mx-auto" outlined>
      <v-toolbar color="indigo" dark flat>
        <v-toolbar-title>Todos</v-toolbar-title>
        <v-spacer></v-spacer>

        <v-tooltip bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-btn icon v-on="on" v-bind="attrs" @click="todoFormDialog = true">
              <v-icon>mdi-plus</v-icon>
            </v-btn>
          </template>
          <span>Add New Todo</span>
        </v-tooltip>
      </v-toolbar>

      <v-list dense>
        <template v-for="(item, index) in todos">
          <v-list-item dense :key="index">
            <v-list-item-action>
              <v-checkbox
                v-model="item.done"
                @change="handleDone(item.id, item.done)"
              ></v-checkbox>
            </v-list-item-action>
            <v-list-item-content>
              <v-list-item-title v-html="item.name"></v-list-item-title>
              <v-list-item-subtitle style="position: relative">
                {{ formatDate(item.created, item.edited) }}
                <v-btn
                  style="position: absolute; right: 0"
                  icon
                  x-small
                  color="error"
                  @click="deleteTodo(item.id)"
                >
                  <v-icon x-small>mdi-delete</v-icon></v-btn
                >
              </v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
        </template>
      </v-list>
    </v-card>
    <todo-form
      :dialog="todoFormDialog"
      @close="todoFormDialog = false"
      @submit="newTodo"
    />
  </v-container>
</template>

<script>
import { TodoApi } from "../services/todos";
import moment from "moment";
import TodoForm from "./TodoForm.vue";
export default {
  name: "TodoList",
  components: {
    TodoForm,
  },
  data: () => ({
    todos: [],
    todoFormDialog: false,
  }),
  created() {
    this.getTodos();
  },
  methods: {
    async getTodos() {
      const res = await TodoApi.getAllTodos();
      this.todos = res.todos;
    },
    formatDate(createdDate, editedDate) {
      if (editedDate == 0 || !editedDate) {
        return "Created " + moment(new Date(createdDate * 1000)).fromNow();
      } else {
        return "Edited " + moment(new Date(editedDate * 1000)).fromNow();
      }
    },
    async handleDone(id, done) {
      const data = {
        done: done,
      };
      const res = await TodoApi.updateTodo(id, data);
      const index = this.todos.findIndex((t) => t.id == res.todo?.id);
      this.todos[index].edited = res.todo.edited;
    },
    async newTodo(todo) {
      const data = {
        name: todo,
      };
      const res = await TodoApi.createTodo(data);
      this.todos.push(res.todo);
      this.todoFormDialog = false;
    },
    async deleteTodo(id) {
      const res = await TodoApi.deleteTodo(id);
      console.log(res);
      this.todos = this.todos.filter((t) => t.id != id);
    },
  },
};
</script>
